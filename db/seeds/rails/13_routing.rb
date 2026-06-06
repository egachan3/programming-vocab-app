# Rails - ルーティングに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'ルーティング', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'resources',
    description: 'RESTfulなルーティングを一括で定義するメソッド。index・show・new・create・edit・update・destroyの7アクションへのルートをまとめて生成する。onlyやexceptで絞り込める。',
    code_example: <<~'RUBY',
      resources :users
      # GET    /users          users#index
      # GET    /users/:id      users#show
      # GET    /users/new      users#new
      # POST   /users          users#create
      # GET    /users/:id/edit users#edit
      # PATCH  /users/:id      users#update
      # DELETE /users/:id      users#destroy

      # 必要なアクションのみ定義
      resources :articles, only: [:index, :show]
      resources :comments, except: [:destroy]

      # ネストしたリソース
      resources :users do
        resources :posts
      end
    RUBY
    level: 1
  },
  {
    term: 'resource',
    description: '単数形のRESTfulルーティングを定義するメソッド。URLにidが含まれない。ユーザー自身のプロフィールなど、1ユーザーに1つしか存在しないリソースに使う。',
    code_example: <<~'RUBY',
      resource :profile
      # GET    /profile      profiles#show
      # GET    /profile/new  profiles#new
      # POST   /profile      profiles#create
      # GET    /profile/edit profiles#edit
      # PATCH  /profile      profiles#update
      # DELETE /profile      profiles#destroy
    RUBY
    level: 1
  },
  {
    term: 'root',
    description: 'アプリケーションのルートURL（/）へのルーティングを定義するメソッド。',
    code_example: <<~'RUBY',
      root "large_categories#index"
      # GET / => large_categories#index

      # 条件付きで切り替える場合
      root to: "pages#top"
    RUBY
    level: 1
  },
  {
    term: 'get',
    description: 'GETメソッドのルーティングを定義するメソッド。データの取得・表示に使うHTTPメソッド。',
    code_example: <<~'RUBY',
      get "/about", to: "pages#about"
      get "/search", to: "words#search", as: :search_words

      # パスパラメーターを含む場合
      get "/users/:id/profile", to: "users#profile"
    RUBY
    level: 1
  },
  {
    term: 'post',
    description: 'POSTメソッドのルーティングを定義するメソッド。データの作成・送信に使うHTTPメソッド。',
    code_example: <<~'RUBY',
      post "/guest_login", to: "guest_sessions#create", as: :guest_login
      post "/contact",     to: "contacts#create"
    RUBY
    level: 1
  },
  {
    term: 'patch',
    description: 'PATCHメソッドのルーティングを定義するメソッド。データの部分的な更新に使うHTTPメソッド。Railsではupdateアクションにデフォルトで使われる。',
    code_example: <<~'RUBY',
      patch "/users/:id", to: "users#update"

      # put も同様（全体更新の意味合いだが Rails では同じ扱い）
      put "/users/:id", to: "users#update"
    RUBY
    level: 1
  },
  {
    term: 'delete',
    description: 'DELETEメソッドのルーティングを定義するメソッド。データの削除に使うHTTPメソッド。',
    code_example: <<~'RUBY',
      delete "/users/:id", to: "users#destroy"
      delete "/logout",    to: "sessions#destroy", as: :logout
    RUBY
    level: 1
  },
  {
    term: 'namespace',
    description: 'URLパスとモジュールの名前空間をまとめてグループ化するメソッド。管理画面など特定の役割ごとにルーティングを分けるときに使う。',
    code_example: <<~'RUBY',
      namespace :admin do
        resources :users
        resources :articles
      end
      # GET /admin/users     => Admin::UsersController#index
      # GET /admin/articles  => Admin::ArticlesController#index

      # コントローラーは app/controllers/admin/ に配置する
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'scope',
    description: 'URLパスのプレフィックスやモジュール・名前などをまとめて設定するメソッド。namespaceより細かく制御できる。',
    code_example: <<~'RUBY',
      # URLにプレフィックスを付けるが、コントローラーのモジュールは変えない
      scope "/api" do
        resources :users
      end
      # GET /api/users => UsersController#index

      # モジュールだけ変える場合
      scope module: :api do
        resources :users
      end
      # GET /users => Api::UsersController#index
    RUBY
    level: 2
  },
  {
    term: 'member',
    description: 'resourcesで生成される個別リソース（:idあり）に対してカスタムアクションを追加するメソッド。',
    code_example: <<~'RUBY',
      resources :users do
        member do
          get  :profile
          post :follow
        end
      end
      # GET  /users/:id/profile => users#profile
      # POST /users/:id/follow  => users#follow
    RUBY
    level: 2
  },
  {
    term: 'collection',
    description: 'resourcesで生成されるコレクション（:idなし）に対してカスタムアクションを追加するメソッド。',
    code_example: <<~'RUBY',
      resources :words do
        collection do
          get :search
        end
      end
      # GET /words/search => words#search
    RUBY
    level: 2
  },
  {
    term: 'redirect',
    description: 'ルートレベルでリダイレクトを定義するメソッド。コントローラーを経由せずに特定のURLへリダイレクトさせる。',
    code_example: <<~'RUBY',
      get "/home", to: redirect("/")
      get "/old-path", to: redirect("/new-path")

      # ステータスコードを指定
      get "/old", to: redirect("/new", status: 301)
    RUBY
    level: 2
  },
  {
    term: 'mount',
    description: 'RackアプリケーションやRailsエンジンを特定のパスにマウントするメソッド。Deviseのエンジンや他のgemのルートを組み込むときに使う。',
    code_example: <<~'RUBY',
      mount Sidekiq::Web, at: "/sidekiq"
      mount ActionCable.server, at: "/cable"

      # Deviseも内部でmountを使用している
    RUBY
    level: 2
  },
  {
    term: 'constraints',
    description: 'ルーティングにマッチする条件を制限するメソッド。IPアドレス・ドメイン・パラメーターの形式などで制約を設けられる。',
    code_example: <<~'RUBY',
      # パラメーターの形式を正規表現で制限
      get "/users/:id", to: "users#show",
          constraints: { id: /\d+/ }

      # ブロック形式でIPを制限
      constraints lambda { |req| req.remote_ip == "127.0.0.1" } do
        get "/admin", to: "admin#index"
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'match',
    description: '複数のHTTPメソッドに対応するルーティングを定義するメソッド。viaオプションでメソッドを指定する。特定のメソッドに限定しないためセキュリティに注意が必要。',
    code_example: <<~'RUBY',
      match "/contact", to: "contacts#create", via: [:get, :post]

      # 全メソッドに対応（非推奨）
      match "/path", to: "controller#action", via: :all
    RUBY
    level: 3
  },
  {
    term: 'concern',
    description: '複数のリソースで共通するルーティングをまとめて定義するメソッド。DRYにルーティングを記述できる。',
    code_example: <<~'RUBY',
      concern :commentable do
        resources :comments
      end

      resources :articles, concerns: :commentable
      resources :posts,    concerns: :commentable
      # どちらも /comments ルートが追加される
    RUBY
    level: 3
  },
  {
    term: 'direct',
    description: 'カスタムURLヘルパーを定義するメソッド。既存のルートヘルパーでは表現できないURLを生成するヘルパーを作れる。',
    code_example: <<~'RUBY',
      direct :homepage do
        "https://example.com"
      end

      # ビューで使用
      # homepage_url => "https://example.com"
    RUBY
    level: 3
  },
  {
    term: 'defaults',
    description: 'ルートのデフォルトパラメーターを設定するメソッド。ブロック内のルート全体にデフォルト値を適用できる。',
    code_example: <<~'RUBY',
      defaults format: :json do
        resources :api_users
      end
      # /api_users は常に JSON 形式として扱われる
    RUBY
    level: 3
  },
  {
    term: 'polymorphic_url',
    description: 'ポリモーフィックな関連を持つオブジェクトのURLを生成するヘルパーメソッド。モデルオブジェクトを渡すと自動的に適切なURLヘルパーを呼び出す。',
    code_example: <<~'RUBY',
      polymorphic_url(@article)
      # => article_url(@article) と同じ

      polymorphic_url([:admin, @article])
      # => admin_article_url(@article) と同じ
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
