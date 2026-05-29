# Ruby - ファイル操作に関する用語のシードデータ

category = Category.find_or_create_by!(name: 'ファイル操作', large_category: @ruby_category)

words = [
  {
    term: 'File.open',
    description: 'ファイルを開くクラスメソッド。ブロックを渡すと処理後に自動でファイルをクローズする。',
    code_example: <<~'RUBY',
      # ブロックを使うと自動でクローズされる
      File.open("sample.txt", "r") do |f|
        puts f.read
      end
    RUBY
    level: 2
  },
  {
    term: 'File.read',
    description: 'ファイルの内容を全て読み込んで文字列で返すクラスメソッド。',
    code_example: <<~'RUBY',
      content = File.read("sample.txt")
      puts content
    RUBY
    level: 2
  },
  {
    term: 'File.write',
    description: 'ファイルに文字列を書き込むクラスメソッド。ファイルが存在しない場合は新規作成し、存在する場合は上書きする。',
    code_example: <<~'RUBY',
      File.write("output.txt", "Hello, World!\n")
      # => output.txt に書き込まれる
    RUBY
    level: 2
  },
  {
    term: 'File.exist?',
    description: '指定したパスのファイルが存在するかどうかを確認する述語メソッド。',
    code_example: <<~'RUBY',
      puts File.exist?("sample.txt")  # => true or false

      if File.exist?("config.yml")
        puts "設定ファイルが見つかりました"
      end
    RUBY
    level: 2
  },
  {
    term: 'File.delete',
    description: '指定したファイルを削除するクラスメソッド。複数のファイルパスを渡して一括削除もできる。',
    code_example: <<~'RUBY',
      if File.exist?("temp.txt")
        File.delete("temp.txt")
        puts "削除しました"
      end
    RUBY
    level: 2
  },
  {
    term: 'Dir.glob',
    description: 'ワイルドカードを使ってファイルパスを検索するクラスメソッド。マッチするファイルパスの配列を返す。',
    code_example: <<~'RUBY',
      # カレントディレクトリの全Rubyファイル
      Dir.glob("*.rb").each { |f| puts f }

      # サブディレクトリも含めて検索
      Dir.glob("**/*.rb").each { |f| puts f }
    RUBY
    level: 3
  },
  {
    term: 'IO',
    description: '入出力の基底クラス。`File` クラスの親クラスでもある。標準入力・標準出力・標準エラー出力なども IO オブジェクト。',
    code_example: <<~'RUBY',
      # STDOUT, STDIN, STDERR は IO オブジェクト
      puts STDOUT.class   # => IO
      puts $stdout.class  # => IO

      STDOUT.puts "Hello via STDOUT"
    RUBY
    level: 3
  },
  {
    term: 'gets',
    description: '標準入力から1行読み込むメソッド。末尾に改行文字が含まれるため、`chomp` と組み合わせることが多い。',
    code_example: <<~'RUBY',
      print "名前を入力してください: "
      name = gets.chomp
      puts "こんにちは、#{name}さん！"
    RUBY
    level: 1
  },
  {
    term: '書き込みモード',
    description: 'ファイルを開く際に指定するモード文字列。`"r"`（読み取り）`"w"`（上書き書き込み）`"a"`（追記）`"r+"`（読み書き）などがある。',
    code_example: <<~'RUBY',
      # "w": 新規作成または上書き
      File.open("log.txt", "w") { |f| f.puts "開始" }

      # "a": 既存ファイルに追記
      File.open("log.txt", "a") { |f| f.puts "追記" }

      puts File.read("log.txt")
      # => 開始
      #    追記
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
