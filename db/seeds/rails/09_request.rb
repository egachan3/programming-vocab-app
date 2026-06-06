# Rails - リクエストに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'リクエスト', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'request_method',
    description: 'HTTPリクエストのメソッド（GET・POST・PATCH・DELETE など）を大文字の文字列で返すメソッド。methodと同じだが予約語との衝突を避けるためrequest_methodが推奨される。',
    code_example: <<~'RUBY',
      request.request_method   # => "GET"
      request.request_method   # => "POST"

      # メソッドによって処理を分岐する場合
      if request.request_method == "POST"
        # POST時の処理
      end
    RUBY
    level: 1
  },
  {
    term: 'remote_ip',
    description: 'リクエスト元のIPアドレスを返すメソッド。プロキシやロードバランサーを経由する場合もX-Forwarded-Forヘッダーを考慮して実際のIPを返す。不正アクセスのログ記録などに使う。',
    code_example: <<~'RUBY',
      request.remote_ip   # => "203.0.113.1"

      # ログに記録する例
      logger.info "アクセス元IP: #{request.remote_ip}"
    RUBY
    level: 1
  },
  {
    term: 'fullpath',
    description: 'クエリストリングを含むリクエストのパスを返すメソッド。ログの記録やリダイレクト先の保存などに使う。',
    code_example: <<~'RUBY',
      # URL: http://example.com/users?page=2&sort=name
      request.fullpath   # => "/users?page=2&sort=name"
    RUBY
    level: 1
  },
  {
    term: 'original_url',
    description: 'プロトコル・ホスト・パスを含むリクエストの完全なURLを返すメソッド。',
    code_example: <<~'RUBY',
      # URL: http://example.com/users?page=2
      request.original_url   # => "http://example.com/users?page=2"
    RUBY
    level: 1
  },
  {
    term: 'xml_http_request?',
    description: 'リクエストがAjax（XMLHttpRequest）かどうかを確認するメソッド。xhr?とも書ける。Ajaxリクエストとそれ以外で処理を分けたいときに使う。',
    code_example: <<~'RUBY',
      request.xml_http_request?   # => true or false
      request.xhr?                # => 同上（省略形）

      if request.xhr?
        render json: @data
      else
        render :index
      end
    RUBY
    level: 1
  },
  {
    term: 'headers',
    description: 'リクエストのHTTPヘッダーを取得するメソッド。Authorizationヘッダーやカスタムヘッダーの取得に使う。',
    code_example: <<~'RUBY',
      request.headers["Content-Type"]
      # => "application/json"

      request.headers["Authorization"]
      # => "Bearer xxxxx"

      request.headers["X-Custom-Header"]
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'body',
    description: 'リクエストのボディ（本文）をIOオブジェクトとして返すメソッド。JSONやXMLなどの生のリクエストボディを読み取るときに使う。',
    code_example: <<~'RUBY',
      raw_body = request.body.read
      data = JSON.parse(raw_body)

      # 読み取り後はrewindで先頭に戻せる
      request.body.rewind
    RUBY
    level: 2
  },
  {
    term: 'ip',
    description: 'リクエスト元のIPアドレスを返すメソッド。remote_ipと異なりX-Forwarded-Forヘッダーを考慮せず直接の接続元のIPを返す。',
    code_example: <<~'RUBY',
      request.ip          # => "127.0.0.1"
      request.remote_ip   # => プロキシ経由でも実際のIPを返す
    RUBY
    level: 2
  },
  {
    term: 'media_type',
    description: 'リクエストのContent-Typeヘッダーのメディアタイプ部分を返すメソッド。リクエストがどの形式のデータを送ってきているかを確認するときに使う。',
    code_example: <<~'RUBY',
      request.media_type   # => "application/json"
      request.media_type   # => "multipart/form-data"
      request.media_type   # => "application/x-www-form-urlencoded"
    RUBY
    level: 2
  },
  {
    term: 'path_parameters',
    description: 'ルーティングで定義されたURLパターンから抽出されたパラメーターをハッシュで返すメソッド。:idや:formatなどが含まれる。',
    code_example: <<~'RUBY',
      # routes: get "/users/:id", to: "users#show"
      # URL: /users/42

      request.path_parameters
      # => { controller: "users", action: "show", id: "42" }
    RUBY
    level: 2
  },
  {
    term: 'form_data?',
    description: 'リクエストのContent-Typeがフォームデータ（application/x-www-form-urlencodedまたはmultipart/form-data）かどうかを確認するメソッド。',
    code_example: <<~'RUBY',
      request.form_data?   # => true（フォーム送信の場合）
      request.form_data?   # => false（JSONリクエストの場合）
    RUBY
    level: 2
  },
  {
    term: 'request_id',
    description: 'リクエストごとに一意なIDを返すメソッド。X-Request-Idヘッダーの値を使用し、なければ自動生成する。ログの追跡や分散システムのトレースに使う。',
    code_example: <<~'RUBY',
      request.request_id
      # => "9a4f2c8e-3b1d-4a7e-8f9c-2d5e6f7a8b9c"

      logger.info "[#{request.request_id}] 処理開始"
    RUBY
    level: 2
  },
  {
    term: 'local?',
    description: 'リクエストがローカル環境（127.0.0.1 または ::1）からのものかを確認するメソッド。開発環境かどうかの判定や、デバッグ情報の表示制御に使う。',
    code_example: <<~'RUBY',
      request.local?   # => true（localhostからのアクセスの場合）

      if request.local?
        render :debug_page
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'raw_post',
    description: 'POSTリクエストの生のボディ文字列を返すメソッド。WebhookのペイロードをHMAC署名検証する際などに使う。',
    code_example: <<~'RUBY',
      payload = request.raw_post
      # => '{"event":"push","repository":{"id":1}}'

      # 署名検証の例
      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
    RUBY
    level: 3
  },
  {
    term: 'authorization',
    description: 'リクエストのAuthorizationヘッダーの値を返すメソッド。API認証でBearerトークンやBasic認証の情報を取得するときに使う。',
    code_example: <<~'RUBY',
      request.authorization
      # => "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

      token = request.authorization&.split(" ")&.last
    RUBY
    level: 3
  },
  {
    term: 'original_fullpath',
    description: 'Rackミドルウェアでリダイレクトが発生した場合でも、元のリクエストのフルパスを返すメソッド。fullpathと同じ値になることが多いが、内部リダイレクト時に差が出る。',
    code_example: <<~'RUBY',
      request.original_fullpath
      # => "/users?page=1"（内部リダイレクト前の元のパス）
    RUBY
    level: 3
  },
  {
    term: 'content_length',
    description: 'リクエストボディのバイト数を返すメソッド。ファイルアップロードのサイズ確認やリクエストのバリデーションに使う。',
    code_example: <<~'RUBY',
      request.content_length
      # => 1024（バイト数）

      if request.content_length > 10.megabytes
        render json: { error: "ファイルが大きすぎます" }, status: :payload_too_large
      end
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
