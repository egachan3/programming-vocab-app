# Rails - クッキー・キャッシュに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'クッキー・キャッシュ', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'cache（ビューキャッシュ）',
    description: 'ビューの一部をキャッシュするヘルパーメソッド。ブロック内の描画結果を保存し、次回以降はDBへのクエリなしに返せる。モデルオブジェクトのcache_keyを使うと自動で有効期限が管理される。',
    code_example: <<~'ERB',
      <%# 単一オブジェクトのキャッシュ %>
      <% cache @article do %>
        <%= render @article %>
      <% end %>

      <%# コレクションのキャッシュ %>
      <% cache ["articles", @articles.maximum(:updated_at)] do %>
        <%= render @articles %>
      <% end %>
    ERB
    level: 1
  },
  {
    term: 'cookies',
    description: 'クッキーを読み書きするためのオブジェクト。コントローラーやビューからアクセスできる。キー・値のハッシュのように操作できる。永続化にはpermanent、改ざん防止にはsigned、暗号化にはencryptedを使う。',
    code_example: <<~'RUBY',
      # クッキーを読む
      cookies[:user_name]

      # クッキーを書く
      cookies[:user_name] = "Alice"

      # オプション付きで書く
      cookies[:token] = {
        value:    "abc123",
        expires:  1.week.from_now,
        httponly: true,
        secure:   true
      }
    RUBY
    level: 1
  },
  {
    term: 'permanent',
    description: 'クッキーを20年間有効な永続クッキーとして保存するメソッド。ログイン状態の保持など長期間保存が必要なデータに使う。',
    code_example: <<~'RUBY',
      cookies.permanent[:user_id] = current_user.id
      # 20年間有効なクッキーをセット

      # signed と組み合わせる
      cookies.permanent.signed[:user_id] = current_user.id
    RUBY
    level: 1
  },
  {
    term: 'signed',
    description: 'クッキーの値にHMAC署名を付加して改ざんを検知できるようにするメソッド。通常のcookiesと異なり、値が変更された場合にnilを返す。',
    code_example: <<~'RUBY',
      # 署名付きクッキーをセット
      cookies.signed[:user_id] = current_user.id

      # 読み取り（改ざんされていればnil）
      user_id = cookies.signed[:user_id]
      # => 1（正常時）or nil（改ざん時）
    RUBY
    level: 1
  },
  {
    term: 'encrypted',
    description: 'クッキーの値を暗号化して保存するメソッド。値が暗号化されるためクライアントから内容を読み取ることができない。機密情報の保存に使う。',
    code_example: <<~'RUBY',
      # 暗号化クッキーをセット
      cookies.encrypted[:user_id] = current_user.id

      # 読み取り（自動で復号される）
      cookies.encrypted[:user_id]
      # => 1
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'delete（cookies）',
    description: '指定したクッキーを削除するメソッド。ログアウト処理などクッキーを無効化したいときに使う。',
    code_example: <<~'RUBY',
      cookies.delete(:user_id)
      cookies.delete(:token, domain: "example.com")
    RUBY
    level: 2
  },
  {
    term: 'expire_fragment',
    description: 'フラグメントキャッシュを期限切れにする（削除する）メソッド。データが更新されたときにキャッシュを無効化して古いデータが表示されないようにする。',
    code_example: <<~'RUBY',
      # コントローラーでキャッシュを期限切れにする
      def update
        @article.update!(article_params)
        expire_fragment(@article)
        redirect_to @article
      end

      # キー文字列で指定する場合
      expire_fragment("articles/#{@article.id}")
    RUBY
    level: 2
  },
  {
    term: 'fragment_exist?',
    description: '指定したキーのフラグメントキャッシュが存在するかを確認するメソッド。キャッシュの有無に応じて処理を分岐するときに使う。',
    code_example: <<~'RUBY',
      if fragment_exist?(["article", @article])
        # キャッシュが存在する場合
        logger.info "キャッシュヒット"
      else
        # キャッシュがない場合は生成する
        @article.rebuild_cache
      end
    RUBY
    level: 2
  },
  {
    term: 'write_fragment',
    description: 'フラグメントキャッシュに値を手動で書き込むメソッド。ビューのcacheヘルパーを使わずにプログラム的にキャッシュを操作するときに使う。',
    code_example: <<~'RUBY',
      html = render_to_string(partial: "articles/article", locals: { article: @article })
      write_fragment(["article", @article], html)
    RUBY
    level: 2
  },
  {
    term: 'reset_session',
    description: 'セッションをリセットして新しいセッションを開始するメソッド。ログイン・ログアウト時にセッション固定攻撃を防ぐために使う。',
    code_example: <<~'RUBY',
      def destroy
        reset_session   # セッション固定攻撃対策
        redirect_to root_path, notice: "ログアウトしました"
      end

      def create
        if authenticate(params[:email], params[:password])
          reset_session   # ログイン前のセッションをリセット
          session[:user_id] = user.id
        end
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'session_id',
    description: '現在のセッションのIDを返すメソッド。デバッグやログの記録、セッション管理に使う。',
    code_example: <<~'RUBY',
      request.session.id
      # => "a1b2c3d4e5f6..."

      logger.info "セッションID: #{request.session.id}"
    RUBY
    level: 3
  },
  {
    term: 'https!',
    description: 'リクエストをHTTPSとして扱うように設定するメソッド。開発環境でHTTPSのテストを行うときや、リバースプロキシの背後でHTTPSを強制するときに使う。',
    code_example: <<~'RUBY',
      # config/environments/production.rb
      config.force_ssl = true

      # コントローラー内で個別に設定する場合
      before_action do
        request.https! if Rails.env.production?
      end
    RUBY
    level: 3
  },
  {
    term: 'fragment_cache_key',
    description: 'フラグメントキャッシュに使用するキーを生成するメソッド。cacheヘルパーに渡した引数からキャッシュストア上のキー文字列を取得するときに使う。',
    code_example: <<~'RUBY',
      fragment_cache_key(["article", @article])
      # => "views/articles/1-20240101000000"
      # ビュー名とupdated_atが組み合わさったキーが返る
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
