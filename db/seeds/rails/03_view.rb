# Rails - ビューに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'ビュー', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'link_to',
    description: 'HTMLのリンク（<a>タグ）を生成するヘルパーメソッド。テキスト・パスヘルパー・オプションを指定できる。ブロックを渡すと画像など複雑な内容もリンクにできる。',
    code_example: <<~'ERB',
      <%= link_to "ユーザー一覧", users_path %>
      <%= link_to "詳細", user_path(@user), class: "btn" %>

      <%= link_to user_path(@user) do %>
        <strong><%= @user.name %></strong>
      <% end %>
    ERB
    level: 1
  },
  {
    term: 'button_to',
    description: 'フォームとボタンを生成するヘルパーメソッド。link_toと異なりデフォルトでPOSTリクエストを送る。削除ボタンなどDELETEメソッドを使う場合に便利。',
    code_example: <<~'ERB',
      <%= button_to "削除", user_path(@user), method: :delete,
          data: { turbo_confirm: "本当に削除しますか？" } %>

      <%= button_to "ログアウト", destroy_user_session_path, method: :delete %>
    ERB
    level: 1
  },
  {
    term: 'image_tag',
    description: 'HTMLの画像タグ（<img>）を生成するヘルパーメソッド。app/assets/images/配下のファイル名やURLを指定する。alt属性も設定できる。',
    code_example: <<~'ERB',
      <%= image_tag "logo.png", alt: "ロゴ", class: "logo" %>
      <%= image_tag "https://example.com/image.jpg", width: 100 %>
    ERB
    level: 1
  },
  {
    term: 'yield',
    description: 'レイアウトファイルの中でビューの内容を挿入する場所を指定するキーワード。引数なしでメインコンテンツを、引数ありでcontent_forで指定したブロックを挿入する。',
    code_example: <<~'ERB',
      <%# layouts/application.html.erb %>
      <body>
        <main>
          <%= yield %>          <%# ビューのメインコンテンツが入る %>
        </main>
        <%= yield :scripts %>   <%# content_for :scripts の内容が入る %>
      </body>
    ERB
    level: 1
  },
  {
    term: 'content_for',
    description: 'レイアウトの特定の位置に挿入するコンテンツを定義するメソッド。yieldと組み合わせて使う。ページごとにタイトルや追加スクリプトを変えるときに便利。',
    code_example: <<~'ERB',
      <%# ビューファイル内 %>
      <% content_for :title do %>
        ユーザー詳細
      <% end %>

      <% content_for :scripts do %>
        <script>console.log("このページ限定のスクリプト")</script>
      <% end %>
    ERB
    level: 1
  },
  {
    term: 'tag',
    description: '任意のHTMLタグを生成するヘルパーメソッド。tag.divやtag.spanのように呼び出す。Railsの推奨する書き方で、content_tagより簡潔に書ける。',
    code_example: <<~'ERB',
      <%= tag.div class: "container" do %>
        <p>コンテンツ</p>
      <% end %>

      <%= tag.span @user.name, class: "name" %>
      <%= tag.p "メッセージ", class: "alert alert-info" %>
    ERB
    level: 1
  },
  {
    term: 'url_for',
    description: 'URLを文字列として生成するヘルパーメソッド。パスヘルパーと同様に使えるが、モデルオブジェクトを渡すと自動的にルートを判断してURLを生成する。',
    code_example: <<~'ERB',
      <%= url_for @user %>
      <%# => "http://localhost:3000/users/1" %>

      <%= url_for action: :index %>
      <%# => "http://localhost:3000/users" %>
    ERB
    level: 1
  },
  {
    term: 'current_page?',
    description: '現在のURLが指定したパスと一致するか判定するヘルパーメソッド。ナビゲーションのアクティブ状態を切り替えるときによく使う。',
    code_example: <<~'ERB',
      <%= link_to "ホーム", root_path,
          class: current_page?(root_path) ? "active" : "" %>

      <% if current_page?(users_path) %>
        <p>ユーザー一覧を表示中</p>
      <% end %>
    ERB
    level: 1
  },
  {
    term: 'csrf_meta_tags',
    description: 'CSRFトークンをmetaタグとして出力するヘルパーメソッド。Railsのレイアウトに標準で含まれており、JavaScriptからAjaxリクエストを行う際に使われる。',
    code_example: <<~'ERB',
      <%# layouts/application.html.erb の <head> 内 %>
      <%= csrf_meta_tags %>
      <%# => <meta name="csrf-param" content="authenticity_token">
      #    <meta name="csrf-token" content="xxxx..."> %>
    ERB
    level: 1
  },
  {
    term: 'simple_format',
    description: '改行を<br>や<p>タグに変換するヘルパーメソッド。テキストエリアで入力した改行をHTMLとして表示したいときに使う。',
    code_example: <<~'ERB',
      <%= simple_format @article.body %>
      <%# 改行が <p> タグと <br> に変換される %>
    ERB
    level: 1
  },
  {
    term: 'truncate',
    description: '文字列を指定した長さで切り詰めるヘルパーメソッド。切り詰めた末尾にはデフォルトで「...」が付く。一覧画面での説明文表示などに使う。',
    code_example: <<~'ERB',
      <%= truncate @article.body, length: 100 %>
      <%= truncate @article.body, length: 50, omission: "…続きを読む" %>
    ERB
    level: 1
  },
  {
    term: 'content_tag',
    description: '任意のHTMLタグを生成するヘルパーメソッド。第1引数にタグ名、第2引数にコンテンツを指定する。tagヘルパーの旧来の書き方。',
    code_example: <<~'ERB',
      <%= content_tag :div, "コンテンツ", class: "container" %>
      <%= content_tag :p, @user.name, class: "name" %>
    ERB
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'link_to_unless_current',
    description: '現在のページと一致しない場合のみリンクを生成するヘルパーメソッド。現在のページの場合はリンクなしのテキストを表示する。ナビゲーションに使う。',
    code_example: <<~'ERB',
      <%= link_to_unless_current "ホーム", root_path %>
      <%# 現在のページが / の場合はリンクなし、それ以外はリンクを生成 %>
    ERB
    level: 2
  },
  {
    term: 'mail_to',
    description: 'メールアドレスへのリンク（mailto:）を生成するヘルパーメソッド。件名や本文をあらかじめ指定することもできる。',
    code_example: <<~'ERB',
      <%= mail_to "support@example.com" %>
      <%= mail_to "support@example.com", "お問い合わせ",
          subject: "ご質問", body: "こんにちは" %>
    ERB
    level: 2
  },
  {
    term: 'javascript_include_tag',
    description: 'JavaScriptファイルを読み込む<script>タグを生成するヘルパーメソッド。app/assets/javascripts/配下のファイルを指定する。',
    code_example: <<~'ERB',
      <%= javascript_include_tag "application" %>
      <%= javascript_include_tag "https://cdn.example.com/script.js" %>
    ERB
    level: 2
  },
  {
    term: 'stylesheet_link_tag',
    description: 'CSSファイルを読み込む<link>タグを生成するヘルパーメソッド。app/assets/stylesheets/配下のファイルを指定する。',
    code_example: <<~'ERB',
      <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    ERB
    level: 2
  },
  {
    term: 'debug',
    description: 'オブジェクトをYAML形式で出力するヘルパーメソッド。開発中にビューでオブジェクトの内容を確認するデバッグ用途に使う。',
    code_example: <<~'ERB',
      <%= debug @user %>
      <%# YAMLフォーマットで <pre> タグに包まれて出力される %>
    ERB
    level: 2
  },
  {
    term: 'highlight',
    description: '文字列の中から指定したキーワードを<mark>タグで強調表示するヘルパーメソッド。検索結果のキーワードハイライトなどに使う。',
    code_example: <<~'ERB',
      <%= highlight @article.title, params[:q] %>
      <%# キーワード部分が <mark>キーワード</mark> に変換される %>
    ERB
    level: 2
  },
  {
    term: 'excerpt',
    description: '文字列の中から指定したキーワードを含む部分を抜き出すヘルパーメソッド。検索結果の前後の文脈を表示するときに使う。',
    code_example: <<~'ERB',
      <%= excerpt @article.body, "Rails", radius: 50 %>
      <%# キーワード前後50文字を抜き出す %>
    ERB
    level: 2
  },
  {
    term: 'raw',
    description: 'HTMLエスケープをせずに文字列をそのまま出力するメソッド。Railsではデフォルトでエスケープされるが、信頼できるHTMLを出力したいときに使う。XSSに注意が必要。',
    code_example: <<~'ERB',
      <%= raw "<strong>太字</strong>" %>
      <%# エスケープされずそのままHTMLとして出力される %>
    ERB
    level: 2
  },
  {
    term: 'time_ago_in_words',
    description: '指定した時刻から現在までの経過時間を「3分前」「約2時間前」などの自然な言葉で返すヘルパーメソッド。投稿日時の表示などに使う。',
    code_example: <<~'ERB',
      <%= time_ago_in_words(@article.created_at) %>
      <%# => "約3時間" %>

      <%= "#{time_ago_in_words(@article.created_at)}前" %>
      <%# => "約3時間前" %>
    ERB
    level: 2
  },
  {
    term: 'escape_javascript',
    description: '文字列内のシングルクォート・ダブルクォート・改行などJavaScriptで問題になる文字をエスケープするヘルパーメソッド。ERBをJavaScript文字列に埋め込む際に使う。',
    code_example: <<~'ERB',
      <script>
        var message = "<%= escape_javascript @user.name %>";
      </script>
    ERB
    level: 2
  },
  {
    term: 'dom_id',
    description: 'Active RecordオブジェクトのHTMLのid属性値を生成するヘルパーメソッド。モデル名とIDを組み合わせた文字列を返す。TurboのDOMターゲット指定によく使う。',
    code_example: <<~'ERB',
      <%= dom_id @user %>
      <%# => "user_1" %>

      <div id="<%= dom_id @article %>">
        <%= @article.title %>
      </div>
    ERB
    level: 2
  },
  {
    term: 'safe_join',
    description: '配列の要素をHTMLセーフな状態で結合するヘルパーメソッド。joinと異なりHTMLエスケープが適切に処理されるため安全に使える。',
    code_example: <<~'ERB',
      <%= safe_join(@tags.map { |t| tag.span(t.name) }, ", ") %>
    ERB
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'audio_tag',
    description: 'HTMLのaudioタグを生成するヘルパーメソッド。音声ファイルをビューに埋め込むときに使う。',
    code_example: <<~'ERB',
      <%= audio_tag "music.mp3", controls: true %>
    ERB
    level: 3
  },
  {
    term: 'video_tag',
    description: 'HTMLのvideoタグを生成するヘルパーメソッド。動画ファイルをビューに埋め込むときに使う。',
    code_example: <<~'ERB',
      <%= video_tag "movie.mp4", controls: true, width: "640" %>
    ERB
    level: 3
  },
  {
    term: 'favicon_link_tag',
    description: 'ファビコン（ブラウザタブのアイコン）を指定する<link>タグを生成するヘルパーメソッド。',
    code_example: <<~'ERB',
      <%= favicon_link_tag "favicon.ico" %>
    ERB
    level: 3
  },
  {
    term: 'cache_if',
    description: '条件が真のときにキャッシュを行うヘルパーメソッド。条件に応じてキャッシュの有無を切り替えたいときに使う。',
    code_example: <<~'ERB',
      <% cache_if user_signed_in?, @article do %>
        <%= render @article %>
      <% end %>
    ERB
    level: 3
  },
  {
    term: 'cache_unless',
    description: '条件が偽のときにキャッシュを行うヘルパーメソッド。cache_ifの反対。',
    code_example: <<~'ERB',
      <% cache_unless admin_user?, @article do %>
        <%= render @article %>
      <% end %>
    ERB
    level: 3
  },
  {
    term: 'strip_tags',
    description: '文字列からHTMLタグをすべて取り除くヘルパーメソッド。HTMLを含む文字列をプレーンテキストとして表示したいときに使う。',
    code_example: <<~'ERB',
      <%= strip_tags "<p>こんにちは<strong>世界</strong></p>" %>
      <%# => "こんにちは世界" %>
    ERB
    level: 3
  },
  {
    term: 'sanitize',
    description: '許可されたタグと属性のみを残してHTMLを安全にするヘルパーメソッド。ユーザー入力のHTMLを表示するときにXSSを防ぐために使う。',
    code_example: <<~'ERB',
      <%= sanitize @article.body,
          tags: %w[p br strong em],
          attributes: %w[class] %>
    ERB
    level: 3
  },
  {
    term: 'capture',
    description: 'ERBのブロックをHTMLとして文字列にキャプチャするヘルパーメソッド。ビューの一部を変数に格納して再利用したいときに使う。',
    code_example: <<~'ERB',
      <% header = capture do %>
        <h1>タイトル</h1>
        <p>サブタイトル</p>
      <% end %>

      <%= header %>
    ERB
    level: 3
  },
  {
    term: 'csp_meta_tag',
    description: 'Content Security Policyのnonceをmetaタグとして出力するヘルパーメソッド。インラインスクリプトをCSPで許可するために使う。csrf_meta_tagsとセットでheadに記述する。',
    code_example: <<~'ERB',
      <%# layouts/application.html.erb の <head> 内 %>
      <%= csp_meta_tag %>
    ERB
    level: 3
  }
]

words.each do |word_attrs|
  Word.find_or_create_by!(term: word_attrs[:term], category: category) do |word|
    word.description = word_attrs[:description]
    word.code_example = word_attrs[:code_example]
    word.level = word_attrs[:level]
  end
end
