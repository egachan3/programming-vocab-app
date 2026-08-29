require 'rails_helper'

# public/*.html のカスタムエラーページが実際に配信されることを検証する。
#
# test環境は consider_all_requests_local = true のため、通常はRailsのデバッグ用
# 例外ページが返る。ここでは本番と同じ配信経路を通すために詳細例外表示を無効化している。
RSpec.describe "エラーページ", type: :request do
  around do |example|
    key = "action_dispatch.show_detailed_exceptions"
    original = Rails.application.env_config[key]
    Rails.application.env_config[key] = false
    example.run
    Rails.application.env_config[key] = original
  end

  describe "404" do
    before { sign_in create(:user) }

    it "存在しないリソースへのアクセスで、日本語のカスタム404ページが配信される" do
      get word_path(id: 0)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("ページが見つかりませんでした")
    end

    it "404ページに検索エンジン向けのnoindexが指定されている" do
      get word_path(id: 0)

      expect(response.body).to include('name="robots"').and include("noindex")
    end

    it "404ページから内部情報(スタックトレース等)が漏れていない" do
      get word_path(id: 0)

      expect(response.body).not_to include("ActiveRecord::RecordNotFound")
      expect(response.body).not_to include("app/controllers")
    end
  end
end
