# N+1クエリや不要なeager loadingを開発中に検知する。
# developmentグループのgemのため、他環境ではBulletが未ロードでも初期化処理自体は動くようにガードする。
if defined?(Bullet)
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true
      Bullet.alert = false
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.rails_logger = true
      Bullet.add_footer = true
    end
  end
end
