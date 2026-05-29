# Ruby - 文字列操作に関する用語のシードデータ

category = Category.find_or_create_by!(name: '文字列操作', large_category: @ruby_category)

words = [
  {
    term: 'length/size',
    description: '文字列の文字数を返すメソッド。`length` と `size` は同じ動作をする。',
    code_example: <<~'RUBY',
      puts "hello".length  # => 5
      puts "こんにちは".size  # => 5（文字数）
    RUBY
    level: 1
  },
  {
    term: 'upcase/downcase',
    description: '`upcase` は文字列を大文字に、`downcase` は小文字に変換する。',
    code_example: <<~'RUBY',
      puts "hello".upcase    # => HELLO
      puts "WORLD".downcase  # => world
      puts "Hello".swapcase  # => hELLO
    RUBY
    level: 1
  },
  {
    term: 'strip',
    description: '文字列の先頭と末尾の空白文字（スペース・タブ・改行など）を取り除く。`lstrip`（左のみ）`rstrip`（右のみ）もある。',
    code_example: <<~'RUBY',
      str = "  hello  "
      puts str.strip    # => "hello"
      puts str.lstrip   # => "hello  "
      puts str.rstrip   # => "  hello"
    RUBY
    level: 1
  },
  {
    term: 'chomp',
    description: '文字列末尾の改行文字（`\n`, `\r\n`）を取り除く。引数を渡すとその文字列を末尾から取り除く。',
    code_example: <<~'RUBY',
      puts "hello\n".chomp     # => hello
      puts "hello\r\n".chomp   # => hello
      puts "hello!".chomp("!") # => hello
    RUBY
    level: 1
  },
  {
    term: 'split',
    description: '指定した区切り文字で文字列を分割して配列を返す。引数を省略すると空白文字で分割する。',
    code_example: <<~'RUBY',
      p "a,b,c".split(",")    # => ["a", "b", "c"]
      p "hello world".split   # => ["hello", "world"]
      p "a,b,c".split(",", 2) # => ["a", "b,c"]（最大分割数を指定）
    RUBY
    level: 1
  },
  {
    term: 'join',
    description: '配列の要素を結合して文字列にするメソッド。区切り文字を引数で指定できる。',
    code_example: <<~'RUBY',
      p ["a", "b", "c"].join        # => "abc"
      p ["a", "b", "c"].join(", ")  # => "a, b, c"
      p [1, 2, 3].join("-")         # => "1-2-3"
    RUBY
    level: 1
  },
  {
    term: 'gsub',
    description: '文字列中の一致する全ての部分を置換する。正規表現も使える。`gsub!` は破壊的バージョン。',
    code_example: <<~'RUBY',
      puts "hello world".gsub("o", "0")  # => hell0 w0rld
      puts "foo bar".gsub(/[aeiou]/, "*") # => f** b*r
    RUBY
    level: 2
  },
  {
    term: 'sub',
    description: '文字列中の最初に一致する部分だけを置換する。`gsub` が全置換なのに対し、`sub` は最初の1件のみ。',
    code_example: <<~'RUBY',
      puts "hello hello".sub("hello", "bye")   # => bye hello
      puts "hello hello".gsub("hello", "bye")  # => bye bye
    RUBY
    level: 2
  },
  {
    term: 'include?',
    description: '指定した文字列が含まれているかどうかを返す述語メソッド。',
    code_example: <<~'RUBY',
      puts "hello world".include?("world")  # => true
      puts "hello world".include?("ruby")   # => false
    RUBY
    level: 1
  },
  {
    term: 'start_with?/end_with?',
    description: '`start_with?` は文字列が指定の文字列で始まるか、`end_with?` は指定の文字列で終わるかを返す。',
    code_example: <<~'RUBY',
      puts "hello".start_with?("he")   # => true
      puts "hello".start_with?("lo")   # => false
      puts "hello".end_with?("lo")     # => true
    RUBY
    level: 2
  },
  {
    term: 'slice/[]',
    description: '文字列の一部を切り出す。`[]` でインデックスや範囲を指定できる。',
    code_example: <<~'RUBY',
      str = "hello"
      puts str[0]      # => h（インデックス）
      puts str[1, 3]   # => ell（開始位置, 長さ）
      puts str[1..3]   # => ell（Range）
      puts str[-2..]   # => lo（末尾から）
    RUBY
    level: 2
  },
  {
    term: 'format/%',
    description: '`format`（または `sprintf`）や `%` 演算子を使って文字列をフォーマットする。C言語の printf に似た書式を使う。',
    code_example: <<~'RUBY',
      puts format("%.2f", 3.14159)        # => 3.14
      puts format("%05d", 42)             # => 00042
      puts "Hello, %s!" % "Alice"         # => Hello, Alice!
      puts "%d + %d = %d" % [1, 2, 3]    # => 1 + 2 = 3
    RUBY
    level: 2
  },
  {
    term: 'freeze',
    description: 'オブジェクトを凍結して変更不可にする。文字列に使うと内容を変更しようとしたとき `FrozenError` が発生する。',
    code_example: <<~'RUBY',
      str = "hello".freeze
      puts str.frozen?  # => true
      # str << " world"  # => FrozenError: can't modify frozen String
    RUBY
    level: 3
  },
  {
    term: 'encode',
    description: '文字列のエンコーディングを変換するメソッド。異なる文字コード間の変換に使う。',
    code_example: <<~'RUBY',
      str = "こんにちは"
      puts str.encoding            # => UTF-8

      encoded = str.encode("Shift_JIS")
      puts encoded.encoding        # => Shift_JIS
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
