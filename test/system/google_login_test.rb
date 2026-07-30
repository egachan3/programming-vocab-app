require "application_system_test_case"

class GoogleLoginTest < ApplicationSystemTestCase
  teardown do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  test "Googleでログインボタンから新規ユーザーとしてログインできる" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "system-test-uid",
      info: OmniAuth::AuthHash::InfoHash.new(email: "system-test@example.com", email_verified: true)
    )

    visit new_user_session_path
    click_on "Googleでログイン"

    assert_text "Googleアカウントで認証しました。"
  end

  test "メールアドレスが未検証のGoogleアカウントではログインできない" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "unverified-uid",
      info: OmniAuth::AuthHash::InfoHash.new(email: "unverified@example.com", email_verified: false)
    )

    visit new_user_session_path
    click_on "Googleでログイン"

    assert_text "メールアドレスが確認されていないGoogleアカウントではログインできません。"
  end

  test "Google認証に失敗した場合はログイン画面にエラーが表示される" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    visit new_user_session_path
    click_on "Googleでログイン"

    assert_text "Google認証に失敗しました。"
  end
end
