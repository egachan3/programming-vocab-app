# Ruby - 条件分岐に関する用語のシードデータ

category = Category.find_or_create_by!(name: '条件分岐', large_category: @ruby_category)

words = [
  {
    term: 'if',
    description: '条件が真（true）のときにブロックを実行する基本的な条件分岐。',
    code_example: <<~'RUBY',
      score = 80

      if score >= 60
        puts "合格"
      end
      # => 合格
    RUBY
    level: 1
  },
  {
    term: 'elsif/else',
    description: '`if` に続けて複数の条件分岐を追加する。`elsif` で追加条件、`else` でどれにも当てはまらない場合の処理を書く。',
    code_example: <<~'RUBY',
      score = 75

      if score >= 90
        puts "優"
      elsif score >= 70
        puts "良"
      elsif score >= 60
        puts "可"
      else
        puts "不可"
      end
      # => 良
    RUBY
    level: 1
  },
  {
    term: 'unless',
    description: '条件が偽（false または nil）のときに実行する。`if !条件` と同じ意味だが、より読みやすい。',
    code_example: <<~'RUBY',
      logged_in = false

      unless logged_in
        puts "ログインしてください"
      end
      # => ログインしてください
    RUBY
    level: 1
  },
  {
    term: 'case/when',
    description: '値を複数のパターンと比較して処理を分岐する。`===` 演算子で比較されるため、クラスや Range との比較も可能。',
    code_example: <<~'RUBY',
      grade = "B"

      case grade
      when "A"
        puts "優秀"
      when "B", "C"
        puts "良好"
      when "D"
        puts "要努力"
      else
        puts "不明"
      end
      # => 良好
    RUBY
    level: 2
  },
  {
    term: '後置if',
    description: '処理の後ろに `if 条件` を付ける書き方。単純な1行の条件付き実行をシンプルに書ける。',
    code_example: <<~'RUBY',
      age = 20
      puts "成人です" if age >= 18
      # => 成人です

      score = 50
      puts "合格" if score >= 60
      # 何も出力されない
    RUBY
    level: 2
  },
  {
    term: '後置unless',
    description: '処理の後ろに `unless 条件` を付ける書き方。条件が偽のときだけ実行する。',
    code_example: <<~'RUBY',
      error = nil
      puts "正常終了" unless error
      # => 正常終了

      logged_in = false
      puts "ゲストです" unless logged_in
      # => ゲストです
    RUBY
    level: 2
  },
  {
    term: 'then',
    description: '`if` や `case/when` などで条件と処理を1行に書くときに使う。通常の複数行の書き方ではほとんど使わない。',
    code_example: <<~'RUBY',
      x = 5
      if x > 0 then puts "正の数" end
      # => 正の数

      case x
      when 1..5 then puts "1から5"
      else           puts "それ以外"
      end
      # => 1から5
    RUBY
    level: 2
  },
  {
    term: '条件式の戻り値',
    description: 'Rubyの `if` や `case` は式であり、評価された分岐の最後の値を返す。変数への代入にも使える。',
    code_example: <<~'RUBY',
      score = 80

      result = if score >= 60
                 "合格"
               else
                 "不合格"
               end

      puts result  # => 合格

      label = case score
              when 90..100 then "A"
              when 70..89  then "B"
              else              "C"
              end
      puts label  # => B
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
