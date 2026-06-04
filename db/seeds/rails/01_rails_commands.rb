# Rails - railsコマンドに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'railsコマンド', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'rails new',
    description: '新しいRailsアプリケーションを作成するコマンド。指定した名前のディレクトリを作成し、必要なファイルとgemを自動で生成する。',
    code_example: <<~'SHELL',
      rails new myapp
      # データベースをPostgreSQLに指定する場合
      rails new myapp -d postgresql
      # APIモードで作成する場合
      rails new myapp --api
    SHELL
    level: 1
  },
  {
    term: 'rails server',
    description: '開発用のWebサーバーを起動するコマンド。デフォルトではlocalhost:3000で起動する。`rails s` と省略できる。',
    code_example: <<~'SHELL',
      rails server
      # 省略形
      rails s
      # ポートを指定する場合
      rails s -p 4000
    SHELL
    level: 1
  },
  {
    term: 'rails console',
    description: 'Railsの環境を読み込んだ状態でRubyの対話的シェル（IRB）を起動するコマンド。モデルの動作確認やデータの操作に使う。`rails c` と省略できる。',
    code_example: <<~'SHELL',
      rails console
      # 省略形
      rails c
      # 本番環境で起動する場合
      rails c -e production
    SHELL
    level: 1
  },
  {
    term: 'rails generate model',
    description: 'モデルファイルとマイグレーションファイルを生成するコマンド。カラム名と型を合わせて指定できる。`rails g model` と省略できる。',
    code_example: <<~'SHELL',
      rails generate model User name:string email:string age:integer
      # 省略形
      rails g model Article title:string body:text
    SHELL
    level: 1
  },
  {
    term: 'rails generate controller',
    description: 'コントローラーファイルとビューファイルを生成するコマンド。アクション名を続けて指定すると対応するビューも生成される。`rails g controller` と省略できる。',
    code_example: <<~'SHELL',
      rails generate controller Users index show
      # 省略形
      rails g controller Pages home about
    SHELL
    level: 1
  },
  {
    term: 'rails generate migration',
    description: 'マイグレーションファイルのみを生成するコマンド。既存のテーブルにカラムを追加・削除するときなどに使う。`rails g migration` と省略できる。',
    code_example: <<~'SHELL',
      rails generate migration AddAgeToUsers age:integer
      # カラムを削除する場合
      rails g migration RemoveAgeFromUsers age:integer
    SHELL
    level: 1
  },
  {
    term: 'rails db:create',
    description: 'database.ymlの設定に基づいてデータベースを作成するコマンド。アプリ開発の最初に実行する。',
    code_example: <<~'SHELL',
      rails db:create
    SHELL
    level: 1
  },
  {
    term: 'rails db:migrate',
    description: 'まだ実行されていないマイグレーションファイルを順番に実行してデータベースのスキーマを更新するコマンド。',
    code_example: <<~'SHELL',
      rails db:migrate
      # 特定のバージョンまでマイグレーションする場合
      rails db:migrate VERSION=20240101000000
    SHELL
    level: 1
  },
  {
    term: 'rails db:rollback',
    description: '直前のマイグレーションを取り消すコマンド。マイグレーションに誤りがあったときに使う。STEPオプションで戻す件数を指定できる。',
    code_example: <<~'SHELL',
      rails db:rollback
      # 3件分戻す場合
      rails db:rollback STEP=3
    SHELL
    level: 1
  },
  {
    term: 'rails db:seed',
    description: 'db/seeds.rbに書かれた初期データをデータベースに投入するコマンド。開発・テスト環境のデータ準備に使う。',
    code_example: <<~'SHELL',
      rails db:seed
    SHELL
    level: 1
  },
  {
    term: 'rails db:reset',
    description: 'データベースを削除してから再作成し、マイグレーションとシードを実行するコマンド。db:drop + db:setup と同じ効果。',
    code_example: <<~'SHELL',
      rails db:reset
    SHELL
    level: 1
  },
  {
    term: 'rails routes',
    description: 'アプリケーションで定義されているルーティングの一覧を表示するコマンド。パス・HTTPメソッド・コントローラー・アクションが確認できる。',
    code_example: <<~'SHELL',
      rails routes
      # 特定のコントローラーに絞り込む場合
      rails routes -c users
      # キーワードで検索する場合
      rails routes | grep users
    SHELL
    level: 1
  },
  {
    term: 'rails destroy',
    description: 'rails generateで生成したファイルを削除するコマンド。generateと同じ引数を渡すことで、生成されたすべてのファイルをまとめて削除できる。`rails d` と省略できる。',
    code_example: <<~'SHELL',
      rails destroy model User
      # 省略形
      rails d controller Users
    SHELL
    level: 1
  },
  {
    term: 'rails about',
    description: 'RailsやRuby、Rack、データベースアダプターなど環境情報の一覧を表示するコマンド。',
    code_example: <<~'SHELL',
      rails about
    SHELL
    level: 1
  },
  {
    term: 'rails version',
    description: '現在インストールされているRailsのバージョンを表示するコマンド。',
    code_example: <<~'SHELL',
      rails version
      # => Rails 8.1.0
    SHELL
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'rails generate scaffold',
    description: 'モデル・コントローラー・ビュー・マイグレーションなどCRUD操作に必要なファイルを一括生成するコマンド。素早くリソースの雛形を作れる。',
    code_example: <<~'SHELL',
      rails generate scaffold Post title:string body:text
      # 省略形
      rails g scaffold Article title:string published:boolean
    SHELL
    level: 2
  },
  {
    term: 'rails generate scaffold_controller',
    description: 'モデルが既に存在する場合に、コントローラーとビューのみをscaffold形式で生成するコマンド。',
    code_example: <<~'SHELL',
      rails generate scaffold_controller User
    SHELL
    level: 2
  },
  {
    term: 'rails generate resource',
    description: 'モデル・コントローラー・マイグレーション・ルーティングをまとめて生成するコマンド。scaffoldと違いビューは生成しない。',
    code_example: <<~'SHELL',
      rails generate resource Product name:string price:integer
    SHELL
    level: 2
  },
  {
    term: 'rails db:drop',
    description: 'データベースを削除するコマンド。データがすべて消えるため注意が必要。',
    code_example: <<~'SHELL',
      rails db:drop
    SHELL
    level: 2
  },
  {
    term: 'rails db:setup',
    description: 'データベースの作成・マイグレーション・シードデータの投入をまとめて行うコマンド。db:create + db:migrate + db:seed と同じ効果。',
    code_example: <<~'SHELL',
      rails db:setup
    SHELL
    level: 2
  },
  {
    term: 'rails db:prepare',
    description: 'データベースが存在しない場合は作成し、マイグレーションを実行するコマンド。CI環境や初回セットアップに適している。',
    code_example: <<~'SHELL',
      rails db:prepare
    SHELL
    level: 2
  },
  {
    term: 'rails db:schema:load',
    description: 'db/schema.rbからデータベースの構造を構築するコマンド。マイグレーションを1件ずつ実行するより高速に環境を構築できる。',
    code_example: <<~'SHELL',
      rails db:schema:load
    SHELL
    level: 2
  },
  {
    term: 'rails runner',
    description: 'Railsの環境を読み込んだ状態でRubyのスクリプトを実行するコマンド。バッチ処理や定期実行スクリプトに使う。',
    code_example: <<~'SHELL',
      rails runner "User.all.each { |u| puts u.email }"
      # ファイルを指定して実行する場合
      rails runner lib/scripts/batch.rb
    SHELL
    level: 2
  },
  {
    term: 'rails test',
    description: 'テストを実行するコマンド。ファイルや行番号を指定して特定のテストのみ実行することもできる。',
    code_example: <<~'SHELL',
      rails test
      # 特定のファイルのみ実行する場合
      rails test test/models/user_test.rb
    SHELL
    level: 2
  },
  {
    term: 'rails assets:precompile',
    description: 'JavaScriptやCSSなどのアセットファイルをコンパイル・圧縮して本番用ファイルを生成するコマンド。本番デプロイ前に実行する。',
    code_example: <<~'SHELL',
      rails assets:precompile
    SHELL
    level: 2
  },
  {
    term: 'rails stats',
    description: 'アプリケーションのコード行数・クラス数・メソッド数などの統計情報を表示するコマンド。',
    code_example: <<~'SHELL',
      rails stats
    SHELL
    level: 2
  },
  {
    term: 'rails log:clear',
    description: 'log/ディレクトリ内のログファイルを削除するコマンド。ログが肥大化したときに使う。',
    code_example: <<~'SHELL',
      rails log:clear
    SHELL
    level: 2
  },
  {
    term: 'rails secret',
    description: 'ランダムなシークレットキーを生成して表示するコマンド。SECRET_KEY_BASEなどの環境変数の値として使う。',
    code_example: <<~'SHELL',
      rails secret
      # => 3b7cd727ee24e8444053437...（64文字のランダム文字列）
    SHELL
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'rails generate job',
    description: 'Active Jobのジョブクラスを生成するコマンド。バックグラウンドで非同期処理を行うときに使う。',
    code_example: <<~'SHELL',
      rails generate job SendEmail
      # => app/jobs/send_email_job.rb が生成される
    SHELL
    level: 3
  },
  {
    term: 'rails generate mailer',
    description: 'Action Mailerのメーラークラスとビューを生成するコマンド。メール送信機能を実装するときに使う。',
    code_example: <<~'SHELL',
      rails generate mailer UserMailer welcome_email
      # => app/mailers/user_mailer.rb と対応するビューが生成される
    SHELL
    level: 3
  },
  {
    term: 'rails generate channel',
    description: 'Action CableのChannelクラスを生成するコマンド。WebSocketを使ったリアルタイム通信を実装するときに使う。',
    code_example: <<~'SHELL',
      rails generate channel Chat
      # => app/channels/chat_channel.rb が生成される
    SHELL
    level: 3
  },
  {
    term: 'rails action_text:install',
    description: 'Action Textをインストールするコマンド。リッチテキストエディタ（Trix）をアプリに導入できる。',
    code_example: <<~'SHELL',
      rails action_text:install
      rails db:migrate
    SHELL
    level: 3
  },
  {
    term: 'rails active_storage:install',
    description: 'Active Storageをインストールするコマンド。ファイルアップロード機能を実装するためのマイグレーションが生成される。',
    code_example: <<~'SHELL',
      rails active_storage:install
      rails db:migrate
    SHELL
    level: 3
  },
  {
    term: 'rails stimulus:install',
    description: 'StimulusをRailsアプリにインストールするコマンド。JavaScriptフレームワークのStimulusを導入できる。',
    code_example: <<~'SHELL',
      rails stimulus:install
    SHELL
    level: 3
  },
  {
    term: 'rails turbo:install',
    description: 'TurboをRailsアプリにインストールするコマンド。Hotwireの一部であるTurboを導入できる。',
    code_example: <<~'SHELL',
      rails turbo:install
    SHELL
    level: 3
  },
  {
    term: 'rails app:update',
    description: 'Railsを新しいバージョンにアップデートする際に、設定ファイルや初期化ファイルを更新するコマンド。',
    code_example: <<~'SHELL',
      rails app:update
    SHELL
    level: 3
  },
  {
    term: 'rails db:encryption:init',
    description: 'Active Recordの暗号化機能を使うための設定キーを生成するコマンド。機密データをDBに暗号化して保存するときに使う。',
    code_example: <<~'SHELL',
      rails db:encryption:init
      # => credentials.yml.enc に暗号化キーが追記される
    SHELL
    level: 3
  },
  {
    term: 'rails zeitwerk:check',
    description: 'Zeitwerk（Railsのオートローダー）がファイルを正しく認識できるか検証するコマンド。ファイル名とクラス名の対応を確認できる。',
    code_example: <<~'SHELL',
      rails zeitwerk:check
      # => Hold on, I am eager loading the application.
      #    All is good!
    SHELL
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
