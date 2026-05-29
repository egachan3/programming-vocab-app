# Ruby - 組み込みクラスに関する用語のシードデータ

category = Category.find_or_create_by!(name: '組み込みクラス', large_category: @ruby_category)

words = [
  {
    term: 'Object',
    description: 'Rubyのほぼすべてのクラスの基底クラス。`nil?`, `freeze`, `class`, `respond_to?` などの基本メソッドを提供する。',
    code_example: <<~'RUBY',
      puts 42.is_a?(Object)       # => true
      puts "hello".is_a?(Object)  # => true
      puts nil.is_a?(Object)      # => true
    RUBY
    level: 2
  },
  {
    term: 'BasicObject',
    description: 'Rubyのクラス階層の最上位クラス。`Object` よりも少ないメソッドしか持たない。DSL実装などで使われる。',
    code_example: <<~'RUBY',
      class MinimalClass < BasicObject
        def hello
          ::Kernel.puts "Hello!"
        end
      end

      MinimalClass.new.hello  # => Hello!
    RUBY
    level: 3
  },
  {
    term: 'Numeric',
    description: '数値クラス（Integer, Float など）の親クラス。数値に関する共通メソッドを定義している。',
    code_example: <<~'RUBY',
      puts 42.is_a?(Numeric)    # => true
      puts 3.14.is_a?(Numeric)  # => true

      puts 42.abs   # => 42
      puts -5.abs   # => 5
      puts 3.zero?  # => false
    RUBY
    level: 2
  },
  {
    term: 'Enumerable',
    description: '`each` を実装して `include` すると使えるようになる反復処理モジュール。Array や Hash はこれを取り込んでいる。',
    code_example: <<~'RUBY',
      puts [3, 1, 2].sort.inspect    # => [1, 2, 3]
      puts [1, 2, 3].min             # => 1
      puts [1, 2, 3].max             # => 3
      puts [1, 2, 3, 4].sum          # => 10
      puts [1, 2, 3].include?(2)     # => true
    RUBY
    level: 3
  },
  {
    term: 'Comparable',
    description: '`<=>` を実装して `include` すると `<`, `>`, `<=`, `>=`, `between?`, `clamp` などの比較メソッドが使えるようになるモジュール。',
    code_example: <<~'RUBY',
      puts 5.between?(1, 10)  # => true
      puts 5.clamp(1, 4)      # => 4（範囲内に収める）
      puts 3 <=> 5            # => -1
    RUBY
    level: 3
  },
  {
    term: 'Math',
    description: '数学的な演算を行うモジュール。三角関数、対数、平方根などのメソッドを提供する。',
    code_example: <<~'RUBY',
      puts Math::PI          # => 3.141592653589793
      puts Math.sqrt(16)     # => 4.0
      puts Math.log(Math::E) # => 1.0
      puts Math.sin(0)       # => 0.0
    RUBY
    level: 2
  },
  {
    term: 'Time',
    description: '日時を扱う組み込みクラス。現在時刻の取得や時刻の演算ができる。',
    code_example: <<~'RUBY',
      now = Time.now
      puts now.year    # => 現在の年
      puts now.month   # => 現在の月
      puts now.strftime("%Y-%m-%d %H:%M:%S")  # => "2024-01-15 12:00:00"
    RUBY
    level: 1
  },
  {
    term: 'Date',
    description: '日付を扱うクラス（`require \'date\'` が必要）。日付の生成・計算・フォーマットができる。',
    code_example: <<~'RUBY',
      require 'date'

      today = Date.today
      puts today        # => 2024-01-15
      puts today + 7    # => 7日後の日付
      puts today.monday? || today.sunday?  # => 週末かどうか
    RUBY
    level: 2
  },
  {
    term: 'Struct',
    description: '属性を持つシンプルなクラスを簡単に作るクラス。軽量なデータ構造として使われる。',
    code_example: <<~'RUBY',
      Point = Struct.new(:x, :y)

      p = Point.new(1, 2)
      puts p.x  # => 1
      puts p.y  # => 2
      puts p    # => #<struct Point x=1, y=2>
    RUBY
    level: 3
  },
  {
    term: 'OpenStruct',
    description: '動的に属性を追加できる柔軟なデータ構造（`require \'ostruct\'` が必要）。ハッシュよりもオブジェクト指向的に扱える。',
    code_example: <<~'RUBY',
      require 'ostruct'

      person = OpenStruct.new(name: "Alice", age: 30)
      puts person.name  # => Alice

      person.email = "alice@example.com"
      puts person.email  # => alice@example.com
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
