# Rails - モデルに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'モデル', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'new',
    description: '新しいモデルオブジェクトをメモリ上に生成するメソッド。データベースには保存されない。saveを呼び出すことで保存できる。',
    code_example: <<~'RUBY',
      user = User.new
      user = User.new(name: "Alice", email: "alice@example.com")
      user.save
    RUBY
    level: 1
  },
  {
    term: 'create',
    description: 'モデルオブジェクトを生成してデータベースに保存するメソッド。newとsaveを一度に行う。バリデーションに失敗しても例外は発生しないが、create!は例外を発生させる。',
    code_example: <<~'RUBY',
      user = User.create(name: "Alice", email: "alice@example.com")

      # バリデーション失敗時に例外を発生させる
      user = User.create!(name: "Alice", email: "alice@example.com")
    RUBY
    level: 1
  },
  {
    term: 'find',
    description: '主キー（id）でレコードを1件取得するメソッド。該当レコードが存在しない場合はActiveRecord::RecordNotFoundを発生させる。',
    code_example: <<~'RUBY',
      user = User.find(1)
      # => id が 1 のユーザーを返す

      # 複数指定も可能
      users = User.find(1, 2, 3)
    RUBY
    level: 1
  },
  {
    term: 'find_by',
    description: '指定した条件に合う最初の1件を返すメソッド。レコードが存在しない場合はnilを返す（例外を発生させない）。find_by!は存在しない場合に例外を発生させる。',
    code_example: <<~'RUBY',
      user = User.find_by(email: "alice@example.com")

      # 存在しない場合に例外を発生させる
      user = User.find_by!(name: "Alice")
    RUBY
    level: 1
  },
  {
    term: 'all',
    description: 'テーブルの全レコードを取得するメソッド。ActiveRecord::Relationオブジェクトを返すため、whereやorderなどのメソッドをチェーンして使える。',
    code_example: <<~'RUBY',
      users = User.all
      users = User.all.order(:name)
      users = User.all.where(active: true)
    RUBY
    level: 1
  },
  {
    term: 'where',
    description: '条件を指定してレコードを絞り込むメソッド。ActiveRecord::Relationを返すのでチェーン可能。SQLのWHERE句に対応する。',
    code_example: <<~'RUBY',
      # ハッシュで指定
      users = User.where(active: true)

      # プレースホルダーで指定（SQLインジェクション対策）
      users = User.where("age > ?", 18)

      # 複数条件
      users = User.where(active: true, role: "admin")
    RUBY
    level: 1
  },
  {
    term: 'save',
    description: 'モデルオブジェクトをデータベースに保存するメソッド。新規レコードはINSERT、既存レコードはUPDATEが実行される。バリデーション成功でtrue、失敗でfalseを返す。save!は失敗時に例外を発生させる。',
    code_example: <<~'RUBY',
      user = User.new(name: "Alice")
      user.save          # true or false を返す

      user.save!         # 失敗時に例外を発生
    RUBY
    level: 1
  },
  {
    term: 'update',
    description: '指定した属性を更新してデータベースに保存するメソッド。バリデーションも実行される。update!は失敗時に例外を発生させる。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.update(name: "Bob", email: "bob@example.com")

      # 失敗時に例外を発生
      user.update!(name: "Bob")
    RUBY
    level: 1
  },
  {
    term: 'destroy',
    description: 'レコードをデータベースから削除するメソッド。deleteと異なりコールバック（before_destroy / after_destroyなど）が実行される。destroy_allは条件に合う全件を削除する。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.destroy

      # 条件に合う全件を削除
      User.where(active: false).destroy_all
    RUBY
    level: 1
  },
  {
    term: 'first',
    description: '主キー昇順で最初の1件を返すメソッド。引数に数値を渡すと指定件数を返す。',
    code_example: <<~'RUBY',
      user  = User.first
      users = User.first(3)

      User.order(:name).first
    RUBY
    level: 1
  },
  {
    term: 'last',
    description: '主キー昇順で最後の1件を返すメソッド。引数に数値を渡すと指定件数を返す。',
    code_example: <<~'RUBY',
      user  = User.last
      users = User.last(3)
    RUBY
    level: 1
  },
  {
    term: 'count',
    description: 'レコードの件数を返すメソッド。whereと組み合わせて条件に合う件数を取得することが多い。',
    code_example: <<~'RUBY',
      User.count
      # => 100

      User.where(active: true).count
      # => 72
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'find_or_create_by',
    description: '条件に合うレコードを探し、なければ作成して返すメソッド。シードデータや重複登録を防ぎたい場面でよく使う。',
    code_example: <<~'RUBY',
      user = User.find_or_create_by(email: "alice@example.com")

      # ブロックで追加属性を指定（新規作成時のみ実行）
      user = User.find_or_create_by(email: "alice@example.com") do |u|
        u.name = "Alice"
      end
    RUBY
    level: 2
  },
  {
    term: 'find_or_initialize_by',
    description: '条件に合うレコードを探し、なければ新しいオブジェクトを生成して返すメソッド。find_or_create_byと異なり保存はされない。',
    code_example: <<~'RUBY',
      user = User.find_or_initialize_by(email: "alice@example.com")
      user.name = "Alice"
      user.save
    RUBY
    level: 2
  },
  {
    term: 'find_each',
    description: '大量のレコードをバッチ処理するメソッド。デフォルト1000件ずつに分割して取得するためメモリの使用量を抑えられる。大量データの一括処理に使う。',
    code_example: <<~'RUBY',
      User.find_each do |user|
        # 1件ずつ処理（メモリ効率が良い）
        UserMailer.welcome(user).deliver_later
      end

      # バッチサイズを指定
      User.find_each(batch_size: 500) do |user|
        user.update(status: "active")
      end
    RUBY
    level: 2
  },
  {
    term: 'order',
    description: '取得するレコードの並び順を指定するメソッド。SQLのORDER BY句に対応する。ascで昇順、descで降順。',
    code_example: <<~'RUBY',
      User.order(:name)
      User.order(created_at: :desc)
      User.order(name: :asc, created_at: :desc)
    RUBY
    level: 2
  },
  {
    term: 'limit',
    description: '取得するレコードの最大件数を指定するメソッド。SQLのLIMIT句に対応する。offsetと組み合わせてページネーションを実装できる。',
    code_example: <<~'RUBY',
      User.limit(10)
      User.order(:created_at).limit(5)
    RUBY
    level: 2
  },
  {
    term: 'offset',
    description: '取得するレコードの開始位置をずらすメソッド。SQLのOFFSET句に対応する。limitと組み合わせてページネーションを実装する。',
    code_example: <<~'RUBY',
      # 11件目から10件取得（2ページ目）
      User.limit(10).offset(10)
    RUBY
    level: 2
  },
  {
    term: 'pluck',
    description: '指定したカラムの値だけを配列で取得するメソッド。モデルオブジェクトを生成しないためメモリ効率がよく高速。',
    code_example: <<~'RUBY',
      User.pluck(:name)
      # => ["Alice", "Bob", "Charlie"]

      User.pluck(:id, :name)
      # => [[1, "Alice"], [2, "Bob"]]
    RUBY
    level: 2
  },
  {
    term: 'select',
    description: '取得するカラムを指定するメソッド。SQLのSELECT句に対応する。必要なカラムだけ取得することでパフォーマンスを改善できる。',
    code_example: <<~'RUBY',
      User.select(:id, :name, :email)
      User.select("name, LENGTH(name) as name_length")
    RUBY
    level: 2
  },
  {
    term: 'includes',
    description: '関連するモデルをまとめて取得するメソッド。N+1問題を解決するためによく使う。SQLのEager Loadingを行う。',
    code_example: <<~'RUBY',
      # N+1問題が発生するコード
      Post.all.each { |p| puts p.user.name }

      # includesで解決
      Post.includes(:user).each { |p| puts p.user.name }

      # 複数の関連を指定
      Post.includes(:user, :comments)
    RUBY
    level: 2
  },
  {
    term: 'joins',
    description: '関連するテーブルをJOINするメソッド。SQLのINNER JOINに対応する。JOINした条件で絞り込む場合に使う。includesと異なり関連データは取得しない。',
    code_example: <<~'RUBY',
      # コメントが存在する投稿だけ取得
      Post.joins(:comments)

      # JOIN先の条件で絞り込む
      Post.joins(:user).where(users: { active: true })
    RUBY
    level: 2
  },
  {
    term: 'distinct',
    description: '重複するレコードを除いた結果を取得するメソッド。SQLのDISTINCTに対応する。',
    code_example: <<~'RUBY',
      User.select(:name).distinct
      # 名前の重複を除いて取得

      Post.joins(:tags).distinct
    RUBY
    level: 2
  },
  {
    term: 'update_all',
    description: '条件に合う複数のレコードをまとめて更新するメソッド。1件ずつupdateするよりSQL1発で高速。コールバックとバリデーションは実行されない。',
    code_example: <<~'RUBY',
      User.where(active: false).update_all(deleted_at: Time.current)
      Post.where(published: false).update_all(status: "draft")
    RUBY
    level: 2
  },
  {
    term: 'transaction',
    description: 'データベーストランザクションを開始するメソッド。ブロック内の処理が全て成功した場合のみコミットし、例外が発生した場合はロールバックする。',
    code_example: <<~'RUBY',
      ActiveRecord::Base.transaction do
        sender.update!(balance: sender.balance - amount)
        receiver.update!(balance: receiver.balance + amount)
      end
      # どちらかが失敗すると両方ロールバックされる
    RUBY
    level: 2
  },
  {
    term: 'reload',
    description: 'オブジェクトの属性をデータベースから再読み込みするメソッド。他の処理でDBが更新された後に最新の値を取得したいときに使う。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.update(name: "Alice")

      # 他の処理でDBが更新された後
      user.reload
      user.name  # => 最新の値が返る
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'eager_load',
    description: '関連するモデルをLEFT OUTER JOINで一度に取得するメソッド。includesとは異なり常にJOINを使う。JOIN先の条件で絞り込む場合に有効。',
    code_example: <<~'RUBY',
      # コメント数でソートするような場合
      Post.eager_load(:comments).order("comments.created_at desc")
    RUBY
    level: 3
  },
  {
    term: 'preload',
    description: '関連するモデルを別クエリで取得するメソッド。includesと似ているが常に別クエリを発行する。JOIN先で条件を指定できない代わりに、大量データでは効率的なことがある。',
    code_example: <<~'RUBY',
      Post.preload(:user, :comments)
    RUBY
    level: 3
  },
  {
    term: 'default_scope',
    description: 'モデルへのすべてのクエリに自動的に適用されるデフォルトのスコープを定義するクラスメソッド。削除済みフラグや並び順のデフォルト設定に使う。意図しない動作になることもあるため注意が必要。',
    code_example: <<~'RUBY',
      class Article < ApplicationRecord
        default_scope { order(created_at: :desc) }
        default_scope { where(published: true) }
      end

      # デフォルトスコープを外す
      Article.unscoped
    RUBY
    level: 3
  },
  {
    term: 'unscoped',
    description: 'default_scopeやスコープをすべて取り除いた状態でクエリを実行するメソッド。デフォルトスコープが邪魔なときに使う。',
    code_example: <<~'RUBY',
      # default_scope { where(published: true) } が定義されている場合
      Article.all         # => published: true のもののみ
      Article.unscoped    # => 全件取得
    RUBY
    level: 3
  },
  {
    term: 'to_sql',
    description: 'ActiveRecord::Relationが生成するSQL文字列を返すメソッド。デバッグやSQL確認に便利。',
    code_example: <<~'RUBY',
      User.where(active: true).order(:name).limit(10).to_sql
      # => "SELECT \"users\".* FROM \"users\"
      #     WHERE \"users\".\"active\" = true
      #     ORDER BY \"users\".\"name\" ASC LIMIT 10"
    RUBY
    level: 3
  },
  {
    term: 'insert_all',
    description: '複数のレコードを1つのSQLで一括挿入するメソッド。Rails 6以降で使える。コールバックとバリデーションは実行されないが大量データの挿入に高速。',
    code_example: <<~'RUBY',
      User.insert_all([
        { name: "Alice", email: "alice@example.com" },
        { name: "Bob",   email: "bob@example.com" },
        { name: "Carol", email: "carol@example.com" }
      ])
    RUBY
    level: 3
  },
  {
    term: 'average',
    description: '指定したカラムの平均値を返すメソッド。sumは合計、maximumは最大値、minimumは最小値を返す。同じ系統の集計メソッド。',
    code_example: <<~'RUBY',
      Order.average(:amount)       # => 3500.0
      Order.sum(:amount)           # => 350000
      Order.maximum(:amount)       # => 99800
      Order.minimum(:amount)       # => 100
    RUBY
    level: 3
  },
  {
    term: 'group',
    description: '指定したカラムでレコードをグループ化するメソッド。SQLのGROUP BY句に対応する。countやsumなどの集計メソッドと組み合わせて使う。',
    code_example: <<~'RUBY',
      # カテゴリごとの記事数
      Post.group(:category).count
      # => { "tech" => 10, "life" => 5 }

      # 月ごとの売上合計
      Order.group("DATE_TRUNC('month', created_at)").sum(:amount)
    RUBY
    level: 3
  },
  {
    term: 'exists?',
    description: '条件に合うレコードが存在するかどうかをtrue/falseで返すメソッド。countと異なり存在確認だけなら高速。',
    code_example: <<~'RUBY',
      User.exists?(1)
      # => true（id: 1 が存在する場合）

      User.exists?(email: "alice@example.com")
      # => true or false

      User.where(active: true).exists?
    RUBY
    level: 3
  },
  {
    term: 'in_batches',
    description: '大量のレコードをバッチ（塊）に分けて処理するメソッド。find_eachと異なりActiveRecord::Relationオブジェクトを渡すため、バッチ単位でまとめて操作できる。',
    code_example: <<~'RUBY',
      User.in_batches(of: 1000) do |batch|
        batch.update_all(notified: true)
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
