require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "未ログインならトップページを表示する" do
      get root_path

      expect(response).to have_http_status(:success)
    end

    it "ログイン済みなら単語カテゴリ一覧にリダイレクトされる" do
      sign_in create(:user)

      get root_path

      expect(response).to redirect_to(large_categories_path)
    end
  end

  describe "GET /terms" do
    it "利用規約ページを表示する" do
      get terms_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "プライバシーポリシーページを表示する" do
      get privacy_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "OGP・Twitter Cardのメタタグ" do
    it "og:imageに絶対URLでOGP画像を指定している" do
      get root_path

      page = Capybara::Node::Simple.new(response.body)
      expect(page).to have_css('meta[property="og:image"][content="http://www.example.com/ogp.png"]', visible: false)
    end

    it "og:title・og:descriptionが空でない" do
      get root_path

      page = Capybara::Node::Simple.new(response.body)
      og_title = page.find('meta[property="og:title"]', visible: false)[:content]
      og_description = page.find('meta[property="og:description"]', visible: false)[:content]

      expect(og_title).to be_present
      expect(og_description).to be_present
    end

    it "twitter:cardがsummary_large_imageになっている" do
      get root_path

      page = Capybara::Node::Simple.new(response.body)
      expect(page).to have_css('meta[name="twitter:card"][content="summary_large_image"]', visible: false)
    end

    # og:urlにトラッキングパラメータ等が付いたままだと、SNS側で
    # クエリの組み合わせごとに別ページとしてキャッシュされてしまう
    it "og:urlにクエリパラメータを含めない" do
      get root_path, params: { utm_source: "x", foo: "bar" }

      page = Capybara::Node::Simple.new(response.body)
      expect(page).to have_css('meta[property="og:url"][content="http://www.example.com/"]', visible: false)
    end

    it "canonicalリンクがog:urlと同じ値になっている" do
      get root_path

      page = Capybara::Node::Simple.new(response.body)
      og_url = page.find('meta[property="og:url"]', visible: false)[:content]
      canonical = page.find('link[rel="canonical"]', visible: false)[:href]

      expect(canonical).to eq(og_url)
    end
  end

  describe "OGP画像の配信" do
    it "/ogp.pngがPNGとして配信され、1200x630サイズである" do
      get "/ogp.png"

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("image/png")

      # PNGヘッダ直後(バイト16〜23)に幅と高さがビッグエンディアンの32bit整数で格納されている
      width, height = response.body[16, 8].unpack("N2")
      expect([ width, height ]).to eq([ 1200, 630 ])
    end
  end
end
