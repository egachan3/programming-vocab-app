require "test_helper"

class UserTest < ActiveSupport::TestCase
  def google_auth(email:, uid: "google-uid-123")
    OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: uid,
      info: OmniAuth::AuthHash::InfoHash.new(email: email)
    )
  end

  test "未登録のメールアドレスならユーザーを新規作成する" do
    auth = google_auth(email: "new-user@example.com")

    assert_difference("User.count", 1) do
      user = User.from_omniauth(auth)
      assert_equal "new-user@example.com", user.email
      assert_equal "google_oauth2", user.provider
      assert_equal "google-uid-123", user.uid
    end
  end

  test "同じprovider/uidのユーザーが既にいれば新規作成せず取得する" do
    existing = User.create!(email: "existing@example.com", password: Devise.friendly_token[0, 20],
                             provider: "google_oauth2", uid: "uid-abc")
    auth = google_auth(email: "existing@example.com", uid: "uid-abc")

    assert_no_difference("User.count") do
      user = User.from_omniauth(auth)
      assert_equal existing.id, user.id
    end
  end

  test "同じメールアドレスのパスワード認証ユーザーがいれば新規作成せず連携する" do
    existing = User.create!(email: "linked@example.com", password: Devise.friendly_token[0, 20])
    auth = google_auth(email: "linked@example.com", uid: "uid-xyz")

    assert_no_difference("User.count") do
      user = User.from_omniauth(auth)
      assert_equal existing.id, user.id
      assert_equal "google_oauth2", user.reload.provider
      assert_equal "uid-xyz", user.uid
    end
  end
end
