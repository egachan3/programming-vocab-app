# Rails - アソシエーションに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'アソシエーション', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'belongs_to',
    description: '他のモデルに「属する」関連を定義するクラスメソッド。外部キーを持つ側のモデルに定義する。デフォルトで関連先の存在が必須（required: true）。',
    code_example: <<~'RUBY',
      class Post < ApplicationRecord
        belongs_to :user
        # posts.user_id を外部キーとして user を参照する
      end

      post = Post.find(1)
      post.user   # => 関連する User オブジェクト
    RUBY
    level: 1
  },
  {
    term: 'has_one',
    description: '他のモデルを「1つ持つ」関連を定義するクラスメソッド。外部キーは相手側のモデルに存在する。1対1の関係を表す。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        has_one :profile
        # profiles.user_id を外部キーとして profile を参照する
      end

      user = User.find(1)
      user.profile   # => 関連する Profile オブジェクト
    RUBY
    level: 1
  },
  {
    term: 'has_many',
    description: '他のモデルを「複数持つ」関連を定義するクラスメソッド。1対多の関係を表す。外部キーは相手側のモデルに存在する。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        has_many :posts
        has_many :comments, dependent: :destroy
        # dependent: :destroy で関連レコードを一緒に削除
      end

      user = User.find(1)
      user.posts   # => 関連する Post の ActiveRecord::Relation
    RUBY
    level: 1
  },
  {
    term: 'has_and_belongs_to_many',
    description: '中間テーブルを介した多対多の関連を定義するクラスメソッド。中間テーブルにはモデルが不要。モデルが必要な場合はhas_many :through を使う。',
    code_example: <<~'RUBY',
      class Post < ApplicationRecord
        has_and_belongs_to_many :tags
      end

      class Tag < ApplicationRecord
        has_and_belongs_to_many :posts
      end

      # posts_tags 中間テーブルが必要
      post.tags   # => 関連する Tag の配列
    RUBY
    level: 1
  },
  {
    term: 'build',
    description: 'アソシエーションに紐付いた新しいオブジェクトをメモリ上に生成するメソッド。外部キーが自動でセットされる。saveを呼ぶまでDBには保存されない。',
    code_example: <<~'RUBY',
      user = User.find(1)

      # has_many の場合
      post = user.posts.build(title: "新しい投稿")
      post.user_id   # => 1（自動セット）
      post.save

      # has_one の場合
      profile = user.build_profile(bio: "こんにちは")
      profile.save
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'create（アソシエーション）',
    description: 'アソシエーションに紐付いた新しいオブジェクトを生成してDBに保存するメソッド。外部キーが自動でセットされる。buildと異なりsaveが不要。',
    code_example: <<~'RUBY',
      user = User.find(1)

      # has_many の場合
      post = user.posts.create(title: "新しい投稿", body: "本文")
      post.user_id   # => 1（自動セット）

      # has_one の場合
      profile = user.create_profile(bio: "こんにちは")
    RUBY
    level: 2
  },
  {
    term: 'find（アソシエーション）',
    description: 'アソシエーションのスコープ内でidによってレコードを1件取得するメソッド。関連する範囲内に存在しない場合はActiveRecord::RecordNotFoundが発生する。',
    code_example: <<~'RUBY',
      user = User.find(1)

      # user に属する post の中から id: 5 を取得
      post = user.posts.find(5)

      # 別のユーザーのpostを指定するとエラーになる
      # => ActiveRecord::RecordNotFound
    RUBY
    level: 2
  },
  {
    term: 'count（アソシエーション）',
    description: 'アソシエーションのレコード件数をSQLのCOUNTで取得するメソッド。毎回DBにクエリを発行する点がsizeと異なる。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.count     # => 10（SQLを発行）
      user.comments.count  # => 5
    RUBY
    level: 2
  },
  {
    term: 'any?（アソシエーション）',
    description: 'アソシエーションにレコードが1件以上存在するかをtrue/falseで返すメソッド。existsを使いSQLを効率よく発行する。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.any?   # => true or false

      # 条件付きで確認
      user.posts.any? { |p| p.published? }
    RUBY
    level: 2
  },
  {
    term: 'many?（アソシエーション）',
    description: 'アソシエーションのレコードが2件以上存在するかをtrue/falseで返すメソッド。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.many?   # => true（2件以上の場合）
      user.posts.many?   # => false（0件または1件の場合）
    RUBY
    level: 2
  },
  {
    term: 'size（アソシエーション）',
    description: 'アソシエーションのレコード件数を返すメソッド。既にロード済みであればSQLを発行せずメモリ上の件数を返す。countとの違いはキャッシュを活用する点。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.size    # => ロード済みならキャッシュを使用
      user.posts.count   # => 常にSQLを発行

      # includesでロード済みの場合
      user = User.includes(:posts).find(1)
      user.posts.size    # => SQLなしで件数を返す
    RUBY
    level: 2
  },
  {
    term: 'destroy_all（アソシエーション）',
    description: 'アソシエーションに属する全レコードを削除するメソッド。各レコードのdestroyを呼ぶためコールバックが実行される。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.destroy_all
      # user に属する全投稿をコールバック付きで削除

      # 条件付きで削除
      user.posts.where(published: false).destroy_all
    RUBY
    level: 2
  },
  {
    term: 'include?（アソシエーション）',
    description: '指定したオブジェクトがアソシエーションに含まれているかをtrue/falseで返すメソッド。',
    code_example: <<~'RUBY',
      user = User.find(1)
      post = Post.find(5)

      user.posts.include?(post)
      # => true（user の投稿に post が含まれる場合）
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'loaded?',
    description: 'アソシエーションがすでにメモリにロードされているかを確認するメソッド。ロード済みであればSQLを発行しない。N+1問題のデバッグやキャッシュ確認に使う。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.loaded?   # => false（まだ取得していない）

      user.posts.load
      user.posts.loaded?   # => true
    RUBY
    level: 3
  },
  {
    term: 'reload（アソシエーション）',
    description: 'アソシエーションのキャッシュをクリアしてDBから再取得するメソッド。他の処理でDBが更新された後に最新のデータを取得したいときに使う。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.reload   # => DBから最新データを取得
    RUBY
    level: 3
  },
  {
    term: 'replace',
    description: 'アソシエーションのレコードを指定した配列の内容に入れ替えるメソッド。元のレコードは削除（またはnull化）され、新しいレコードが関連付けられる。',
    code_example: <<~'RUBY',
      user = User.find(1)
      new_posts = Post.where(id: [10, 11, 12])

      user.posts.replace(new_posts)
      # 元の投稿との関連を解除し、new_posts を関連付ける
    RUBY
    level: 3
  },
  {
    term: 'delete_all（アソシエーション）',
    description: 'アソシエーションに属する全レコードをSQLのDELETEで一括削除するメソッド。destroy_allと異なりコールバックは実行されないが高速。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.delete_all
      # コールバックなしで全投稿をSQL1発で削除
    RUBY
    level: 3
  },
  {
    term: 'distinct（アソシエーション）',
    description: 'アソシエーションのクエリに DISTINCT を適用して重複を除いたレコードを返すメソッド。joinを使った場合に重複が生じるのを防ぐ。',
    code_example: <<~'RUBY',
      user = User.find(1)
      user.posts.joins(:tags).distinct
      # タグで JOIN した場合の重複を除去
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
