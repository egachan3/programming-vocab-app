# Ruby - ハッシュに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'ハッシュ', large_category: @ruby_category)

words = [
  {
    term: 'ハッシュの作成',
    description: '`{}` を使いキーと値のペアでデータを管理するオブジェクト。キーには任意のオブジェクトを使える。',
    code_example: <<~'RUBY',
      person = { "name" => "Alice", "age" => 30 }
      puts person["name"]  # => Alice

      # Hash.new でも作れる
      h = Hash.new
      h["key"] = "value"
    RUBY
    level: 1
  },
  {
    term: 'キーと値',
    description: 'ハッシュは `キー => 値` のペアで構成される。`[]` でキーを指定して値を取得・設定する。',
    code_example: <<~'RUBY',
      h = { "a" => 1, "b" => 2 }
      puts h["a"]  # => 1

      h["c"] = 3
      p h  # => {"a"=>1, "b"=>2, "c"=>3}
    RUBY
    level: 1
  },
  {
    term: 'シンボルキー',
    description: 'ハッシュのキーにシンボルを使う方法。`:key => value` または `key: value` という糖衣構文で書ける。最もよく使われる形式。',
    code_example: <<~'RUBY',
      # 通常の書き方
      h1 = { :name => "Alice" }

      # 糖衣構文（同じ意味）
      h2 = { name: "Alice", age: 30 }

      puts h2[:name]  # => Alice
      puts h2[:age]   # => 30
    RUBY
    level: 1
  },
  {
    term: 'fetch',
    description: 'キーを指定して値を取得するメソッド。`[]` と異なり、キーが存在しない場合にエラーを発生させる（デフォルト値を指定することも可能）。',
    code_example: <<~'RUBY',
      h = { name: "Alice", age: 30 }

      puts h.fetch(:name)         # => Alice
      puts h.fetch(:role, "user") # => user（デフォルト値）
      # h.fetch(:missing)         # => KeyError
    RUBY
    level: 2
  },
  {
    term: 'merge',
    description: '2つのハッシュを結合した新しいハッシュを返す。同じキーがあった場合は引数のハッシュの値で上書きされる。',
    code_example: <<~'RUBY',
      h1 = { name: "Alice", age: 30 }
      h2 = { age: 31, role: "admin" }

      p h1.merge(h2)
      # => {:name=>"Alice", :age=>31, :role=>"admin"}
    RUBY
    level: 2
  },
  {
    term: 'each',
    description: 'ハッシュの各キーと値のペアに対してブロックを実行するメソッド。',
    code_example: <<~'RUBY',
      h = { name: "Alice", age: 30, role: "admin" }

      h.each do |key, value|
        puts "#{key}: #{value}"
      end
      # => name: Alice
      #    age: 30
      #    role: admin
    RUBY
    level: 1
  },
  {
    term: 'keys/values',
    description: '`keys` はハッシュの全キーの配列を、`values` は全値の配列を返す。',
    code_example: <<~'RUBY',
      h = { name: "Alice", age: 30 }

      p h.keys    # => [:name, :age]
      p h.values  # => ["Alice", 30]
    RUBY
    level: 1
  },
  {
    term: 'dig',
    description: 'ネストしたハッシュ（または配列）から安全に値を取り出すメソッド。途中のキーが存在しなくても `nil` を返す。',
    code_example: <<~'RUBY',
      data = {
        user: {
          name: "Alice",
          address: { city: "Tokyo" }
        }
      }

      puts data.dig(:user, :address, :city)  # => Tokyo
      puts data.dig(:user, :phone).inspect   # => nil（エラーにならない）
    RUBY
    level: 3
  },
  {
    term: 'select/reject',
    description: 'ハッシュでも `select`（条件を満たすペアを残す）と `reject`（条件を満たすペアを除く）が使える。結果はハッシュで返る。',
    code_example: <<~'RUBY',
      h = { a: 1, b: 2, c: 3, d: 4 }

      p h.select { |k, v| v > 2 }  # => {:c=>3, :d=>4}
      p h.reject { |k, v| v > 2 }  # => {:a=>1, :b=>2}
    RUBY
    level: 2
  },
  {
    term: 'any?/all?',
    description: 'ハッシュでも `any?`（いずれかが真）と `all?`（全てが真）が使える。ブロックにはキーと値が渡される。',
    code_example: <<~'RUBY',
      h = { a: 1, b: 2, c: 3 }

      puts h.any? { |k, v| v > 2 }  # => true
      puts h.all? { |k, v| v > 0 }  # => true
    RUBY
    level: 2
  },
  {
    term: 'transform_values',
    description: '全ての値にブロックを適用した新しいハッシュを返す。キーはそのまま保持される。',
    code_example: <<~'RUBY',
      h = { name: "alice", role: "admin" }

      p h.transform_values { |v| v.upcase }
      # => {:name=>"ALICE", :role=>"ADMIN"}
    RUBY
    level: 3
  },
  {
    term: 'default値',
    description: '`Hash.new(デフォルト値)` で作成すると、存在しないキーへのアクセス時にデフォルト値を返す。',
    code_example: <<~'RUBY',
      h = Hash.new(0)
      h[:apple] += 1
      h[:apple] += 1
      h[:banana] += 1

      p h  # => {:apple=>2, :banana=>1}
      puts h[:grape]  # => 0（デフォルト値）
    RUBY
    level: 2
  }
]

words.each do |word_attrs|
  Word.find_or_create_by!(term: word_attrs[:term], category: category) do |word|
    word.description = word_attrs[:description]
    word.code_example = word_attrs[:code_example]
    word.level = word_attrs[:level]
  end
end
