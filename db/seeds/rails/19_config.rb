# Rails - 設定ファイルに関する用語のシードデータ

category = Category.find_or_create_by!(name: '設定ファイル', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'config.eager_load',
    description: 'アプリ起動時にコードを一括読み込みするかを設定する。本番環境ではtrueにしてメモリ効率とスレッドセーフを確保する。開発環境ではfalseにして起動を速くする。関連：config.cache_classes（コードをキャッシュするか）、config.autoload_paths（自動読み込み対象のパス）、config.eager_load_paths（一括読み込み対象のパス）。',
    code_example: <<~'RUBY',
      # config/environments/production.rb
      config.eager_load = true

      # config/environments/development.rb
      config.eager_load = false

      # 自動読み込みパスの追加
      config.autoload_paths << Rails.root.join("lib")
      config.eager_load_paths << Rails.root.join("lib")
    RUBY
    level: 1
  },
  {
    term: 'config.force_ssl',
    description: 'すべてのリクエストをHTTPSに強制するか設定する。本番環境ではtrueにしてHTTP通信を禁止する。関連：config.secret_key_base（暗号化キーの設定）、config.filter_parameters（ログに出力しないパラメーター名の設定。passwordなどを指定する）。',
    code_example: <<~'RUBY',
      # config/environments/production.rb
      config.force_ssl = true

      # config/application.rb
      config.filter_parameters += [:password, :credit_card_number]

      # config/credentials.yml.enc（rails credentials:editで編集）
      # secret_key_base: xxxxxxxxxx
    RUBY
    level: 1
  },
  {
    term: 'config.log_level',
    description: 'ログの出力レベルを設定する。:debug・:info・:warn・:error・:fatal・:unknownから選ぶ。本番環境では:infoや:warnが一般的。関連：config.logger（ロガーオブジェクトの設定）、config.log_tags（ログに付与するタグの設定）、config.log_formatter（ログのフォーマット設定）。',
    code_example: <<~'RUBY',
      # config/environments/production.rb
      config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

      # config/environments/development.rb
      config.log_level = :debug

      # タグ付き（リクエストIDをログに含める）
      config.log_tags = [:request_id]
    RUBY
    level: 1
  },
  {
    term: 'config.time_zone',
    description: 'アプリケーションのデフォルトタイムゾーンを設定する。Active Recordの日時カラムに自動適用される。関連：config.beginning_of_week（週の始まりを設定。:monday等）、config.encoding（デフォルト文字コード設定）、config.active_record.default_timezone（DBへの保存形式を:utcか:localで設定）。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.time_zone = "Tokyo"
      config.beginning_of_week = :monday
      config.encoding = "utf-8"

      # Active Recordのタイムゾーン
      config.active_record.default_timezone = :utc
    RUBY
    level: 1
  },
  {
    term: 'config.session_store',
    description: 'セッションの保存方法を設定する。:cookie_store（デフォルト）・:cache_store・:active_record_storeなどから選ぶ。関連：config.action_dispatch.session_store（Action Dispatch側のセッション設定）。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.session_store :cookie_store, key: "_myapp_session"

      # キャッシュを使う場合
      config.session_store :cache_store

      # データベースを使う場合（activerecord-session_store gem が必要）
      config.session_store :active_record_store
    RUBY
    level: 1
  },
  {
    term: 'config.i18n',
    description: '国際化（i18n）に関する設定。default_localeでデフォルト言語を指定し、load_pathで翻訳ファイルのパスを追加する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.i18n.default_locale = :ja
      config.i18n.available_locales = [:ja, :en]

      # 翻訳ファイルのパスを追加
      config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml")]
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'config.assets',
    description: 'アセットパイプラインに関する設定をまとめたグループ。precompileで本番用にコンパイルするファイルを指定し、pathsで追加の検索パスを設定する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.assets.enabled = true
      config.assets.paths << Rails.root.join("vendor/assets/fonts")
      config.assets.precompile += %w[admin.js admin.css]
      config.assets.prefix = "/assets"

      # config/environments/development.rb
      config.assets.debug = true

      # config/environments/production.rb
      config.assets.digest = true
      config.assets.css_compressor = :sass
    RUBY
    level: 2
  },
  {
    term: 'config.middleware',
    description: 'Rackミドルウェアのスタックを設定する。useで追加・deleteで削除・swapで置換・insert_afterで特定ミドルウェアの後に挿入できる。',
    code_example: <<~'RUBY',
      # config/application.rb

      # ミドルウェアを追加
      config.middleware.use MyCustomMiddleware

      # ミドルウェアを削除
      config.middleware.delete ActionDispatch::Cookies

      # 置換
      config.middleware.swap ActionDispatch::Session::CookieStore,
                             ActionDispatch::Session::CacheStore

      # 特定ミドルウェアの後に挿入
      config.middleware.insert_after ActionDispatch::Cookies,
                                     MySessionMiddleware
    RUBY
    level: 2
  },
  {
    term: 'config.active_record',
    description: 'Active Recordの動作をカスタマイズする設定グループ。テーブル名の規則・タイムゾーン・スキーマ形式などを設定する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.active_record.pluralize_table_names = true  # テーブル名を複数形にする
      config.active_record.table_name_prefix = "app_"   # テーブル名にプレフィックス
      config.active_record.schema_format = :ruby         # schema.rbを使う（:sqlでstructure.sql）
      config.active_record.timestamped_migrations = true # マイグレーションにタイムスタンプ
      config.active_record.logger = Logger.new(STDOUT)
    RUBY
    level: 2
  },
  {
    term: 'config.action_controller',
    description: 'Action Controllerの動作をカスタマイズする設定グループ。キャッシュ・CSRF保護・パラメーター設定などを管理する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.action_controller.perform_caching = true
      config.action_controller.allow_forgery_protection = true
      config.action_controller.permit_all_parameters = false
      config.action_controller.action_on_unpermitted_params = :log
      config.action_controller.default_charset = "utf-8"
    RUBY
    level: 2
  },
  {
    term: 'config.action_view',
    description: 'Action View（ビュー描画）の動作をカスタマイズする設定グループ。エラー表示・フォームビルダー・テンプレートキャッシュなどを設定する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.action_view.field_error_proc = proc do |html_tag, instance|
        "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
      end

      # config/environments/production.rb
      config.action_view.cache_template_loading = true
    RUBY
    level: 2
  },
  {
    term: 'config.action_mailer',
    description: 'メール送信に関する設定グループ。送信方法（SMTP・Sendmailなど）・エラーハンドリング・デフォルト設定を管理する。',
    code_example: <<~'RUBY',
      # config/environments/production.rb
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.raise_delivery_errors = true
      config.action_mailer.perform_deliveries = true
      config.action_mailer.smtp_settings = {
        address:              "smtp.gmail.com",
        port:                 587,
        user_name:            ENV["GMAIL_USER"],
        password:             ENV["GMAIL_PASS"],
        authentication:       :plain,
        enable_starttls_auto: true
      }

      # config/environments/development.rb
      config.action_mailer.delivery_method = :letter_opener
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'config.active_support',
    description: 'Active Supportの動作をカスタマイズする設定グループ。JSON出力形式や非推奨警告の動作などを設定する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.active_support.escape_html_entities_in_json = true
      config.active_support.use_standard_json_time_format = true

      # 非推奨警告の設定
      ActiveSupport::Deprecation.behavior = :raise   # 例外として発生させる
      ActiveSupport::Deprecation.silenced = false     # 警告を表示する
    RUBY
    level: 3
  },
  {
    term: 'config.credentials',
    description: '暗号化された認証情報ファイル（config/credentials.yml.enc）のパスを設定する。master.keyで復号し、APIキーやパスワードなどの機密情報を安全に管理する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.credentials.content_path = Rails.root.join("config/credentials.yml.enc")
      config.credentials.key_path     = Rails.root.join("config/master.key")

      # 認証情報へのアクセス
      Rails.application.credentials.secret_key_base
      Rails.application.credentials.dig(:aws, :access_key_id)
    RUBY
    level: 3
  },
  {
    term: 'config.action_dispatch',
    description: 'HTTPリクエストの処理に関する設定グループ。デフォルトレスポンスヘッダー・TLDの長さ・セッションストアなどを管理する。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.action_dispatch.default_headers = {
        "X-Frame-Options"        => "SAMEORIGIN",
        "X-XSS-Protection"       => "1; mode=block",
        "X-Content-Type-Options" => "nosniff"
      }

      config.action_dispatch.tld_length = 2
      # example.co.jp のような2段階TLDに対応
    RUBY
    level: 3
  },
  {
    term: 'config.exceptions_app',
    description: '例外発生時に呼び出すRackアプリケーションを設定する。デフォルトではpublic/404.htmlなどの静的ファイルが使われるが、カスタムコントローラーで動的なエラーページを返すことができる。関連：config.consider_all_requests_local（trueにすると詳細なエラー画面を全リクエストで表示。開発環境向け）。',
    code_example: <<~'RUBY',
      # config/application.rb
      config.exceptions_app = routes

      # config/routes.rb にエラー用ルートを追加
      match "/404", to: "errors#not_found",     via: :all
      match "/500", to: "errors#internal_error", via: :all

      # config/environments/development.rb
      config.consider_all_requests_local = true
    RUBY
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
