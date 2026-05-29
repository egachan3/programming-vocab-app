# Ruby - データ型に関する用語のシードデータ

category = Category.find_or_create_by!(name: 'データ型', large_category: @ruby_category)

words = [
  {
    term: 'String',
    description: '文字列を表すクラス。シングルクォートまたはダブルクォートで囲む。',
    code_example: <<~'RUBY',
      str1 = "Hello"
      str2 = 'World'
      puts str1.class  # => String
      puts str1 + " " + str2  # => Hello World
    RUBY
    level: 1
  },
  {
    term: 'Integer',
    description: '整数を表すクラス。小数点を含まない数値。',
    code_example: <<~'RUBY',
      n = 42
      puts n.class  # => Integer
      puts n + 8    # => 50
    RUBY
    level: 1
  },
  {
    term: 'Float',
    description: '浮動小数点数を表すクラス。小数点を含む数値。',
    code_example: <<~'RUBY',
      f = 3.14
      puts f.class  # => Float
      puts f * 2    # => 6.28
    RUBY
    level: 1
  },
  {
    term: 'Boolean',
    description: '真偽値を表す `true` と `false` のこと。Rubyでは TrueClass と FalseClass という別々のクラスとして定義されている。',
    code_example: <<~'RUBY',
      puts true.class   # => TrueClass
      puts false.class  # => FalseClass

      flag = true
      puts flag ? "yes" : "no"  # => yes
    RUBY
    level: 1
  },
  {
    term: 'nil',
    description: '値が存在しないことを表す特別なオブジェクト。NilClass のインスタンス。条件式ではfalseとして扱われる。',
    code_example: <<~'RUBY',
      value = nil
      puts value.nil?    # => true
      puts value.class   # => NilClass

      puts "empty" if value.nil?  # => empty
    RUBY
    level: 1
  },
  {
    term: 'Symbol',
    description: 'コロン（:）で始まる不変の識別子。文字列と似ているが、同じシンボルは常に同一オブジェクトのため軽量で高速。',
    code_example: <<~'RUBY',
      sym = :hello
      puts sym.class   # => Symbol
      puts sym         # => hello

      # 同じシンボルは同一オブジェクト
      puts :hello.equal?(:hello)  # => true
    RUBY
    level: 2
  },
  {
    term: 'Range',
    description: '数値や文字の連続した範囲を表すオブジェクト。`..` で終端を含み、`...` で終端を含まない。',
    code_example: <<~'RUBY',
      r = 1..5
      puts r.include?(3)   # => true
      puts r.to_a.inspect  # => [1, 2, 3, 4, 5]

      r2 = 1...5
      puts r2.to_a.inspect  # => [1, 2, 3, 4]
    RUBY
    level: 1
  },
  {
    term: '文字列と数値の変換',
    description: '`to_i` で文字列を整数に、`to_f` で浮動小数点数に、`to_s` で数値を文字列に変換できる。',
    code_example: <<~'RUBY',
      puts "42".to_i    # => 42
      puts "3.14".to_f  # => 3.14
      puts 100.to_s     # => "100"

      # 変換できない場合は0または空文字になる
      puts "abc".to_i   # => 0
    RUBY
    level: 1
  },
  {
    term: '整数リテラル',
    description: '2進数（0b）・8進数（0o）・16進数（0x）などの異なる基数でも整数を表記できる。',
    code_example: <<~'RUBY',
      puts 0b1010   # => 10（2進数）
      puts 0o17     # => 15（8進数）
      puts 0xFF     # => 255（16進数）

      # アンダースコアで区切ることもできる
      puts 1_000_000  # => 1000000
    RUBY
    level: 2
  },
  {
    term: '文字列の式展開',
    description: 'ダブルクォート文字列内で `#{}` を使い、変数や式を文字列に埋め込む。シングルクォートでは展開されない。',
    code_example: <<~'RUBY',
      name = "Alice"
      age = 30

      puts "名前: #{name}, 年齢: #{age}"  # => 名前: Alice, 年齢: 30
      puts '名前: #{name}'               # => 名前: #{name}（展開されない）
    RUBY
    level: 1
  }
]

words.each do |word_attrs|
  Word.find_or_create_by!(term: word_attrs[:term], category: category) do |word|
    word.description = word_attrs[:description]
    word.code_example = word_attrs[:code_example]
    word.level = word_attrs[:level]
  end
end
