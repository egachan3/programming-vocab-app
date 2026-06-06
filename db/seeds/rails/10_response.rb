# Rails - レスポンスに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'レスポンス', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'content_type',
    description: 'レスポンスのContent-Typeヘッダーを取得・設定するメソッド。ブラウザにどの種類のデータを返すかを伝える。renderメソッドがフォーマットに応じて自動設定するが、手動で指定することもできる。',
    code_example: <<~'RUBY',
      response.content_type
      # => "text/html; charset=utf-8"

      # 手動で設定する場合
      response.content_type = "application/json"

      # APIで明示的にJSONを返す
      render json: @user, content_type: "application/json"
    RUBY
    level: 1
  },
  {
    term: 'cookies',
    description: 'レスポンスに付与するクッキーを操作するためのオブジェクト。値の設定・削除・有効期限の指定ができる。クライアントの情報を保持するために使う。',
    code_example: <<~'RUBY',
      # クッキーをセット
      cookies[:user_name] = "Alice"

      # オプション付きでセット
      cookies[:token] = {
        value:   "abc123",
        expires: 1.week.from_now,
        httponly: true
      }

      # クッキーを削除
      cookies.delete(:user_name)

      # 暗号化クッキー（改ざん防止）
      cookies.encrypted[:user_id] = current_user.id
    RUBY
    level: 1
  },
  {
    term: 'message',
    description: 'HTTPレスポンスのステータスメッセージを返すメソッド。ステータスコードに対応する文字列（"OK"・"Not Found"・"Unauthorized"など）を返す。',
    code_example: <<~'RUBY',
      response.message   # => "OK"（200の場合）
      response.message   # => "Not Found"（404の場合）
      response.message   # => "Unauthorized"（401の場合）
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'body',
    description: 'レスポンスのボディ（クライアントに返す本文）を文字列で返すメソッド。テスト内でレスポンスの内容を検証するときによく使う。',
    code_example: <<~'RUBY',
      # コントローラーのテスト内
      get :index
      response.body
      # => "<html><body>...</body></html>"

      # JSON APIのテスト
      parsed = JSON.parse(response.body)
    RUBY
    level: 2
  },
  {
    term: 'charset',
    description: 'レスポンスの文字コードを取得・設定するメソッド。デフォルトはUTF-8。特殊な用途で文字コードを変更する必要があるときに使う。',
    code_example: <<~'RUBY',
      response.charset
      # => "utf-8"

      # 文字コードを変更する場合（通常は不要）
      response.charset = "shift_jis"
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'send_file',
    description: 'サーバー上のファイルをレスポンスとして送信するメソッド。ファイルパスを指定してダウンロードさせる。send_dataとの違いはデータではなくファイルパスを指定する点。X-Sendfileヘッダーに対応したサーバーではNginxなどに送信を委譲できる。',
    code_example: <<~'RUBY',
      def download
        file_path = Rails.root.join("storage", "reports", "report.pdf")
        send_file file_path,
                  filename: "monthly_report.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
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
