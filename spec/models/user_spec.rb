require 'rails_helper'

RSpec.describe User, type: :model do
  def google_auth(email:, uid: "google-uid-123")
    OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: uid,
      info: OmniAuth::AuthHash::InfoHash.new(email: email)
    )
  end

  describe ".from_omniauth" do
    it "未登録のメールアドレスならユーザーを新規作成する" do
      auth = google_auth(email: "new-user@example.com")

      expect do
        user = User.from_omniauth(auth)
        expect(user.email).to eq("new-user@example.com")
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("google-uid-123")
      end.to change(User, :count).by(1)
    end

    it "同じprovider/uidのユーザーが既にいれば新規作成せず取得する" do
      existing = create(:user, email: "existing@example.com", provider: "google_oauth2", uid: "uid-abc")
      auth = google_auth(email: "existing@example.com", uid: "uid-abc")

      expect do
        user = User.from_omniauth(auth)
        expect(user.id).to eq(existing.id)
      end.not_to change(User, :count)
    end

    it "同じメールアドレスのパスワード認証ユーザーがいれば新規作成せず連携する" do
      existing = create(:user, email: "linked@example.com")
      auth = google_auth(email: "linked@example.com", uid: "uid-xyz")

      expect do
        user = User.from_omniauth(auth)
        expect(user.id).to eq(existing.id)
      end.not_to change(User, :count)

      existing.reload
      expect(existing.provider).to eq("google_oauth2")
      expect(existing.uid).to eq("uid-xyz")
    end
  end
end
