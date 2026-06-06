# Rails - コントローラーに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'コントローラー', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'params',
    description: 'リクエストのパラメータを取得するメソッド。URLのクエリストリング・フォームデータ・ルートパラメータがまとめて含まれる。Strong Parametersと組み合わせてセキュアに使う。',
    code_example: <<~'RUBY',
      def show
        @user = User.find(params[:id])
      end

      # Strong Parametersでの使い方
      def user_params
        params.require(:user).permit(:name, :email)
      end
    RUBY
    level: 1
  },
  {
    term: 'render',
    description: 'ビューテンプレートを描画してレスポンスとして返すメソッド。デフォルトではアクション名と同じビューを描画する。テンプレート・JSON・テキストなど様々な形式を指定できる。',
    code_example: <<~'RUBY',
      # 同名のビューを描画（省略可）
      render :index

      # 別のビューを描画
      render :edit

      # JSONを返す
      render json: @user

      # ステータスコードを指定
      render :new, status: :unprocessable_entity
    RUBY
    level: 1
  },
  {
    term: 'redirect_to',
    description: 'クライアントを別のURLへリダイレクトさせるメソッド。302ステータスコードを返す。パスヘルパーやURLを指定する。',
    code_example: <<~'RUBY',
      def create
        @user = User.new(user_params)
        if @user.save
          redirect_to @user, notice: "作成しました"
        else
          render :new, status: :unprocessable_entity
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'flash',
    description: 'リダイレクト後に一度だけ表示するメッセージを保持するハッシュ。notice（通知）とalert（警告）が代表的なキー。次のリクエストが完了すると自動的に削除される。',
    code_example: <<~'RUBY',
      # コントローラーでセット
      flash[:notice] = "保存しました"
      redirect_to root_path

      # redirect_toと同時に指定
      redirect_to root_path, notice: "保存しました"
      redirect_to root_path, alert: "エラーが発生しました"
    RUBY
    level: 1
  },
  {
    term: 'layout',
    description: 'コントローラーのアクションに適用するレイアウトファイルを指定するメソッド。コントローラー単位・アクション単位で切り替えられる。falseを指定するとレイアウトなしになる。',
    code_example: <<~'RUBY',
      class AdminController < ApplicationController
        layout 'admin'
      end

      # アクションごとに切り替える
      class UsersController < ApplicationController
        layout 'guest', only: [:login]
      end
    RUBY
    level: 1
  },
  {
    term: 'respond_to',
    description: 'リクエストのフォーマット（HTML・JSON・XMLなど）に応じて異なるレスポンスを返すメソッド。APIとHTMLを同じアクションで扱うときに使う。',
    code_example: <<~'RUBY',
      def index
        @users = User.all

        respond_to do |format|
          format.html
          format.json { render json: @users }
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'request',
    description: '現在のHTTPリクエスト情報を保持するオブジェクト。IPアドレス・HTTPメソッド・ヘッダー・URLなどにアクセスできる。',
    code_example: <<~'RUBY',
      request.method      # => "GET"
      request.path        # => "/users"
      request.remote_ip   # => "127.0.0.1"
      request.format      # => Mime[:html]
      request.xhr?        # => false（Ajaxかどうか）
    RUBY
    level: 1
  },
  {
    term: 'head',
    description: 'HTTPステータスコードとヘッダーのみを返すメソッド。ボディのないレスポンスを返すときに使う。APIでの削除処理などに適している。',
    code_example: <<~'RUBY',
      def destroy
        @user.destroy
        head :no_content   # 204 No Content
      end

      # 許可されていない場合
      head :forbidden      # 403 Forbidden
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'redirect_back_or_to',
    description: 'ブラウザの直前のページにリダイレクトするメソッド。直前のページが取得できない場合はデフォルトURLにリダイレクトする。Rails 6.1以降で導入。',
    code_example: <<~'RUBY',
      def update
        @user.update!(user_params)
        redirect_back_or_to root_path, notice: "更新しました"
      end
    RUBY
    level: 2
  },
  {
    term: 'redirect_back',
    description: 'ブラウザの直前のページにリダイレクトするメソッド。Rails 6.0以前の書き方。Rails 6.1以降はredirect_back_or_toが推奨される。',
    code_example: <<~'RUBY',
      # Rails 6.0以前
      redirect_back fallback_location: root_path
    RUBY
    level: 2
  },
  {
    term: 'logger',
    description: 'Railsのログにメッセージを出力するためのオブジェクト。debug・info・warn・errorなどのログレベルを指定できる。log/development.logに記録される。',
    code_example: <<~'RUBY',
      logger.debug "デバッグ情報: #{@user.inspect}"
      logger.info  "ユーザーがログインしました"
      logger.warn  "注意: 不正なアクセスの試み"
      logger.error "エラーが発生しました"
    RUBY
    level: 2
  },
  {
    term: 'protect_from_forgery',
    description: 'CSRF（クロスサイトリクエストフォージェリ）攻撃を防ぐメソッド。Railsではデフォルトで有効になっており、フォームにCSRFトークンを埋め込んで検証する。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        protect_from_forgery with: :exception
      end
    RUBY
    level: 2
  },
  {
    term: 'skip_forgery_protection',
    description: 'CSRF保護をスキップするメソッド。APIエンドポイントなどCSRFトークンが不要な場合に使う。セキュリティリスクがあるため対象を限定して使う。',
    code_example: <<~'RUBY',
      class ApiController < ApplicationController
        skip_forgery_protection
      end

      # 特定のアクションのみスキップ
      skip_forgery_protection only: [:create]
    RUBY
    level: 2
  },
  {
    term: 'send_data',
    description: 'バイナリデータをブラウザに送信するメソッド。CSVやPDFなどのファイルをダウンロードさせるときに使う。',
    code_example: <<~'RUBY',
      def download_csv
        csv_data = generate_csv(@users)
        send_data csv_data,
                  filename: "users.csv",
                  type: "text/csv",
                  disposition: "attachment"
      end
    RUBY
    level: 2
  },
  {
    term: 'send_file',
    description: 'サーバー上のファイルをブラウザに送信するメソッド。ファイルパスを指定してダウンロードさせる。send_dataとの違いはデータではなくファイルパスを渡す点。',
    code_example: <<~'RUBY',
      def download
        send_file Rails.root.join("storage/reports/report.pdf"),
                  filename: "report.pdf",
                  type: "application/pdf"
      end
    RUBY
    level: 2
  },
  {
    term: 'fresh_when',
    description: 'レスポンスが変更されていない場合に304 Not Modifiedを返すメソッド。ETagやLast-Modifiedヘッダーを設定してHTTPキャッシュを活用する。',
    code_example: <<~'RUBY',
      def show
        @article = Article.find(params[:id])
        fresh_when @article
      end
    RUBY
    level: 2
  },
  {
    term: 'stale?',
    description: 'キャッシュが古くなっているかどうかを確認するメソッド。古ければtrueを返し新しいレスポンスを生成する。fresh_whenより細かい制御ができる。',
    code_example: <<~'RUBY',
      def show
        @article = Article.find(params[:id])
        if stale?(@article)
          respond_to do |format|
            format.html
            format.json { render json: @article }
          end
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'expires_in',
    description: 'レスポンスのキャッシュ有効期限を設定するメソッド。Cache-Controlヘッダーにmax-ageを指定する。',
    code_example: <<~'RUBY',
      def index
        expires_in 10.minutes, public: true
        @articles = Article.all
      end
    RUBY
    level: 2
  },
  {
    term: 'expires_now',
    description: 'レスポンスをキャッシュさせないように設定するメソッド。Cache-Control: no-cacheヘッダーを設定する。ログイン後のページなどに使う。',
    code_example: <<~'RUBY',
      def show
        expires_now
        @user = current_user
      end
    RUBY
    level: 2
  },
  {
    term: 'http_basic_authenticate_with',
    description: 'HTTP基本認証を設定するクラスメソッド。簡易的な認証を一行で実装できる。本番環境ではDeviseなどの認証gemを使うことが多い。',
    code_example: <<~'RUBY',
      class AdminController < ApplicationController
        http_basic_authenticate_with(
          name: "admin",
          password: "secret"
        )
      end
    RUBY
    level: 2
  },
  {
    term: 'controller_name',
    description: '現在のコントローラー名を文字列で返すメソッド。コントローラー名に応じた処理の分岐やビューでの動的な制御に使う。',
    code_example: <<~'RUBY',
      controller_name  # => "users"（UsersControllerの場合）

      # ビューでの使用例
      # body要素のclassにコントローラー名を付与
      # <body class="<%= controller_name %>">
    RUBY
    level: 2
  },
  {
    term: 'wrap_parameters',
    description: 'JSONリクエストのパラメータをモデル名のキーで自動的にラップするメソッド。APIモードでフロントエンドからのJSONを受け取るときに使う。',
    code_example: <<~'RUBY',
      # { "name": "Alice" } というJSONを受け取ると
      # params[:user] = { name: "Alice" } として扱える

      class UsersController < ApplicationController
        wrap_parameters :user, include: [:name, :email]
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'render_to_string',
    description: 'ビューテンプレートを描画した結果を文字列として返すメソッド。レスポンスとして返さず、文字列として扱いたいときに使う。メール本文の生成などに便利。',
    code_example: <<~'RUBY',
      html = render_to_string(
        template: "users/show",
        locals: { user: @user }
      )
    RUBY
    level: 3
  },
  {
    term: 'send_stream',
    description: 'ストリーミングレスポンスを送信するメソッド。Rails 7で追加。大きなデータを生成しながら少しずつ送信できるため、メモリ使用量を抑えられる。',
    code_example: <<~'RUBY',
      def download
        send_stream(filename: "large.csv") do |stream|
          stream.write "name,email\n"
          User.find_each do |user|
            stream.write "#{user.name},#{user.email}\n"
          end
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'etag',
    description: 'レスポンスのETagヘッダーを設定するメソッド。コンテンツが変更されたかどうかをブラウザが判断するために使う。変更がなければ304を返しデータ転送を減らせる。',
    code_example: <<~'RUBY',
      def show
        @article = Article.find(params[:id])
        # ETagを手動で設定する場合
        response.etag = @article.cache_key
      end
    RUBY
    level: 3
  },
  {
    term: 'http_cache_forever',
    description: 'レスポンスを永続的にキャッシュするように設定するメソッド。変更されることのない静的コンテンツに使う。public引数でプロキシにもキャッシュさせるか指定できる。',
    code_example: <<~'RUBY',
      def logo
        http_cache_forever(public: true) do
          render file: "public/logo.png"
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'no_store',
    description: 'レスポンスをいかなるキャッシュにも保存させないよう設定するメソッド。個人情報や機密情報を含むページに使う。',
    code_example: <<~'RUBY',
      def account
        no_store
        @user = current_user
      end
    RUBY
    level: 3
  },
  {
    term: 'add_flash_types',
    description: 'カスタムのフラッシュタイプを追加するクラスメソッド。noticeとalert以外の独自フラッシュメッセージを定義できる。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        add_flash_types :success, :danger, :info
      end

      # コントローラーで使用
      redirect_to root_path, success: "成功しました"
    RUBY
    level: 3
  },
  {
    term: 'nonce',
    description: 'Content Security Policy（CSP）のnonceを生成・返すメソッド。インラインスクリプトをCSPで安全に許可するために使う。',
    code_example: <<~'RUBY',
      # config/initializers/content_security_policy.rb
      Rails.application.config.content_security_policy_nonce_generator =
        -> (request) { SecureRandom.base64(16) }

      # ビューで使用
      # <script nonce="<%= content_security_policy_nonce %>">
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
