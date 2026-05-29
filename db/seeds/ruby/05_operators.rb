# Ruby - 演算子に関する用語のシードデータ

category = Category.find_or_create_by!(name: '演算子', large_category: @ruby_category)

words = [
  {
    term: '算術演算子',
    description: '数値の四則演算などに使う演算子。`+`（加算）`-`（減算）`*`（乗算）`/`（除算）`%`（剰余）`**`（べき乗）。',
    code_example: <<~'RUBY',
      puts 10 + 3   # => 13
      puts 10 - 3   # => 7
      puts 10 * 3   # => 30
      puts 10 / 3   # => 3（整数同士は切り捨て）
      puts 10 % 3   # => 1
      puts 2 ** 8   # => 256
    RUBY
    level: 1
  },
  {
    term: '比較演算子',
    description: '2つの値を比較して真偽値を返す演算子。`==`（等しい）`!=`（等しくない）`>`（より大きい）`<`（より小さい）`>=` `<=` など。',
    code_example: <<~'RUBY',
      puts 5 == 5   # => true
      puts 5 != 3   # => true
      puts 5 > 3    # => true
      puts 5 < 3    # => false
      puts 5 >= 5   # => true
    RUBY
    level: 1
  },
  {
    term: '論理演算子',
    description: '複数の条件を組み合わせる演算子。`&&`（AND）`||`（OR）`!`（NOT）。',
    code_example: <<~'RUBY',
      puts true && false  # => false
      puts true || false  # => true
      puts !true          # => false

      x = 5
      puts x > 0 && x < 10  # => true
    RUBY
    level: 1
  },
  {
    term: '三項演算子',
    description: '条件式を1行で書く演算子。`条件 ? 真の値 : 偽の値` の形式で使う。',
    code_example: <<~'RUBY',
      age = 20
      result = age >= 18 ? "成人" : "未成年"
      puts result  # => 成人

      puts 10 > 5 ? "big" : "small"  # => big
    RUBY
    level: 2
  },
  {
    term: '宇宙船演算子',
    description: '`<=>` で2つの値を比較し、左辺が小さければ `-1`、等しければ `0`、大きければ `1` を返す。ソートや Comparable モジュールで使われる。',
    code_example: <<~'RUBY',
      puts 1 <=> 2   # => -1
      puts 2 <=> 2   # => 0
      puts 3 <=> 2   # => 1

      [3, 1, 2].sort { |a, b| a <=> b }.inspect
      # => [1, 2, 3]
    RUBY
    level: 3
  },
  {
    term: '安全演算子',
    description: '`&.`（ぼっち演算子）。レシーバが `nil` のときにエラーを発生させず `nil` を返す。nilチェックのコードを簡潔に書ける。',
    code_example: <<~'RUBY',
      user = nil
      puts user&.name   # => nil（エラーにならない）

      user = "Alice"
      puts user&.upcase  # => ALICE
    RUBY
    level: 2
  },
  {
    term: '代入演算子',
    description: '変数に値を代入する演算子。`=` の他に、`+=`（加算代入）`-=`（減算代入）`*=` `/=` `||=`（nilなら代入）などがある。',
    code_example: <<~'RUBY',
      x = 10
      x += 5   # x = x + 5
      puts x   # => 15

      x *= 2
      puts x   # => 30

      y = nil
      y ||= "default"
      puts y   # => default
    RUBY
    level: 1
  },
  {
    term: '論理演算子英語',
    description: '`and`・`or`・`not` は記号の論理演算子と似た働きをするが、優先順位が大きく異なる。制御フローの可読性向上に使われることがある。',
    code_example: <<~'RUBY',
      # and は && より優先順位が低い
      result = true and false
      puts result  # => true（= の後に and が評価される）

      result = true && false
      puts result  # => false

      # not は ! より優先順位が低い
      puts not true   # => false
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
