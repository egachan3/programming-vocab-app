# Ruby - 基本の出力と構文に関する用語のシードデータ

# seeds.rb で作成した @ruby_category（LargeCategory）を親として、小カテゴリ（Category）を取得または作成する
category = Category.find_or_create_by!(name: '基本の出力と構文', large_category: @ruby_category)

# 登録する単語データをハッシュの配列として定義する
words = [
  {
    term: 'puts',                  # 単語名
    description: '文字列や数値を標準出力に書き出すメソッド。末尾に改行が自動で追加される。配列を渡すと各要素を1行ずつ出力する。', # 説明文
    code_example: <<~'RUBY',      # コード例（<<~'RUBY' はヒアドキュメント。シングルクォートで #{ } の式展開を無効にしている）
      puts "Hello, World!"
      # => Hello, World!

      puts [1, 2, 3]
      # => 1
      #    2
      #    3
    RUBY
    level: 1                       # 難易度（1〜3）
  },
  {
    term: 'print',
    description: '文字列や数値を標準出力に書き出すメソッド。putsと異なり末尾に改行が追加されない。',
    code_example: <<~'RUBY',
      print "Hello"
      print ", World!"
      # => Hello, World!
    RUBY
    level: 1
  },
  {
    term: 'p',
    description: 'オブジェクトをinspectした結果を標準出力に書き出すメソッド。デバッグ用途でよく使われる。戻り値はオブジェクト自身。',
    code_example: <<~'RUBY',
      p "Hello"
      # => "Hello"

      p [1, 2, 3]
      # => [1, 2, 3]
    RUBY
    level: 1
  },
  {
    term: 'pp',
    description: '複雑なオブジェクトを見やすく整形して標準出力に書き出すメソッド。pと似ているが、ネストされたデータ構造を読みやすく表示する。',
    code_example: <<~'RUBY',
      pp({ name: "Alice", scores: [100, 90, 85] })
      # => {:name=>"Alice", :scores=>[100, 90, 85]}
    RUBY
    level: 2
  },
  {
    term: 'require',
    description: '外部ライブラリや標準ライブラリを読み込む',
    code_example: <<~'RUBY',
      require 'date'

      puts Date.today
      # => 2024-01-01
    RUBY
    level: 1
  },
  {
    term: 'require_relative',
    description: '相対パスで別ファイルを読み込む',
    code_example: <<~'RUBY',
      # lib/hello.rb が存在する場合
      require_relative 'lib/hello'
    RUBY
    level: 1
  },
  {
    term: 'load',
    description: 'ファイルを毎回読み込む。requireと異なり再読み込みする',
    code_example: <<~'RUBY',
      load 'config.rb'
      # requireと違い、何度呼び出してもファイルを再実行する
    RUBY
    level: 3
  },
  {
    term: 'コメント',
    description: '`#` で始まる行はコメントとして無視される',
    code_example: <<~'RUBY',
      # これはコメントです
      puts "Hello" # 行末コメントも書ける
    RUBY
    level: 1
  },
  {
    term: '複数行コメント',
    description: '`=begin` 〜 `=end` で複数行をコメントにする',
    code_example: <<~'RUBY',
      =begin
      ここに書いた内容は
      すべてコメントとして扱われる
      =end
      puts "Hello"
    RUBY
    level: 2
  }
]

# words 配列の各ハッシュを1つずつ取り出して単語（Word）を登録する
words.each do |word_attrs|
  # term（単語名）と category の組み合わせで検索し、なければ新規作成する
  # ブロック内の処理は新規作成時のみ実行される（既存レコードは上書きしない）
  Word.find_or_create_by!(term: word_attrs[:term], category: category) do |word|
    word.description = word_attrs[:description]
    word.code_example = word_attrs[:code_example]
    word.level = word_attrs[:level]
  end
end
