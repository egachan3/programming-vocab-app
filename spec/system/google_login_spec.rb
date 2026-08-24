require 'rails_helper'

RSpec.describe "Googleログイン", type: :system do
  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  it "Googleでログインボタンから新規ユーザーとしてログインできる" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "system-test-uid",
      info: OmniAuth::AuthHash::InfoHash.new(email: "system-test@example.com", email_verified: true)
    )

    visit new_user_session_path
    click_on "Googleでログイン"

    expect(page).to have_text("Googleアカウントで認証しました。")
  end

  it "メールアドレスが未検証のGoogleアカウントではログインできない" do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: "unverified-uid",
      info: OmniAuth::AuthHash::InfoHash.new(email: "unverified@example.com", email_verified: false)
    )

    visit new_user_session_path
    click_on "Googleでログイン"

    expect(page).to have_text("メールアドレスが確認されていないGoogleアカウントではログインできません。")
  end

  it "Google認証に失敗した場合はログイン画面にエラーが表示される" do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    visit new_user_session_path
    click_on "Googleでログイン"

    expect(page).to have_text("Google認証に失敗しました。")
  end
end
