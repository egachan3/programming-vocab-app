# Rails - テストに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'テスト', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'テストの基本',
    description: 'Railsには標準でMinitest（テストフレームワーク）が含まれる。テストファイルはtest/配下に置き、rails testコマンドで実行する。RSpecを使う場合はrspec-rails gemを追加する。テストの種類：モデルテスト（ユニットテスト）・コントローラーテスト（ファンクショナルテスト）・インテグレーションテスト・システムテスト。',
    code_example: <<~'RUBY',
      # テストファイルの基本構造
      require "test_helper"

      class UserTest < ActiveSupport::TestCase
        test "名前が空の場合は無効" do
          user = User.new(name: "")
          assert_not user.valid?
        end
      end

      # テストの実行
      # rails test                   # 全テスト
      # rails test test/models/      # モデルテストのみ
      # rails test test/models/user_test.rb  # 特定のファイル
    RUBY
    level: 1
  },
  {
    term: 'フィクスチャ',
    description: 'テスト用のサンプルデータをYAMLファイルで定義する仕組み。test/fixtures/配下に置き、テスト実行時に自動でテストDBに読み込まれる。FactoryBot gemを使う方法もある（フィクスチャより柔軟で可読性が高い）。',
    code_example: <<~'YAML',
      # test/fixtures/users.yml
      alice:
        name: Alice
        email: alice@example.com
        role: admin

      bob:
        name: Bob
        email: bob@example.com
        role: member
    YAML
    level: 1
  },
  {
    term: 'モデルテスト（ユニットテスト）',
    description: 'モデルのバリデーション・メソッド・スコープなどを検証するテスト。test/models/配下に置く。rails generate model コマンドで自動生成される。単一のクラスやメソッドの動作を確認するテストをユニットテストという。',
    code_example: <<~'RUBY',
      # test/models/user_test.rb
      require "test_helper"

      class UserTest < ActiveSupport::TestCase
        test "名前が必須" do
          user = User.new(email: "test@example.com")
          assert_not user.valid?
          assert_includes user.errors[:name], "を入力してください"
        end

        test "メールアドレスが一意" do
          User.create!(name: "Alice", email: "alice@example.com")
          dup = User.new(name: "Bob", email: "alice@example.com")
          assert_not dup.valid?
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'assert（アサーション）',
    description: 'テストの検証に使うメソッド群。期待した結果かどうかを確認し、失敗するとテストが落ちる。主なアサーション：assert/assert_not（真偽）、assert_equal/assert_not_equal（値の一致）、assert_nil（nil確認）、assert_raises（例外確認）、assert_difference（件数変化）、assert_includes（要素の存在）。',
    code_example: <<~'RUBY',
      assert user.valid?
      assert_not user.valid?

      assert_equal "Alice", user.name
      assert_not_equal "Bob", user.name

      assert_nil user.deleted_at
      assert_not_nil user.created_at

      assert_raises(ActiveRecord::RecordNotFound) { User.find(999) }

      assert_difference "User.count", 1 do
        User.create!(name: "Alice", email: "alice@example.com")
      end

      assert_no_difference "User.count" do
        User.new(name: "").save
      end

      assert_includes user.errors[:name], "を入力してください"
    RUBY
    level: 1
  },
  {
    term: 'コントローラーテスト（ファンクショナルテスト）',
    description: 'コントローラーのアクションにHTTPリクエストを送り、レスポンスを検証するテスト。test/controllers/配下に置く。get・post・patch・deleteメソッドでリクエストを送る。',
    code_example: <<~'RUBY',
      # test/controllers/users_controller_test.rb
      require "test_helper"

      class UsersControllerTest < ActionDispatch::IntegrationTest
        test "一覧ページが表示される" do
          get users_url
          assert_response :success
        end

        test "ユーザーを作成できる" do
          assert_difference "User.count", 1 do
            post users_url, params: {
              user: { name: "Alice", email: "alice@example.com" }
            }
          end
          assert_redirected_to user_url(User.last)
        end
      end
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'assert_response',
    description: 'HTTPレスポンスのステータスコードを検証するアサーション。:success（200）・:redirect（3xx）・:not_found（404）・:error（5xx）などのシンボルか数値で指定する。',
    code_example: <<~'RUBY',
      get users_url
      assert_response :success       # 200 OK

      get user_url(999)
      assert_response :not_found     # 404

      assert_response 200            # 数値での指定も可能
      assert_response :redirect      # 301 or 302
    RUBY
    level: 2
  },
  {
    term: 'assert_redirected_to',
    description: 'リダイレクト先のURLを検証するアサーション。パスヘルパー・URLオブジェクト・ハッシュで指定できる。',
    code_example: <<~'RUBY',
      post users_url, params: { user: { name: "Alice", email: "alice@example.com" } }
      assert_redirected_to user_url(User.last)

      delete session_url
      assert_redirected_to root_url

      # コントローラーとアクションで指定
      assert_redirected_to controller: :users, action: :index
    RUBY
    level: 2
  },
  {
    term: 'インテグレーションテスト',
    description: '複数のコントローラーにまたがるワークフロー全体を検証するテスト。test/integration/配下に置く。ログイン→操作→ログアウトのような一連の流れをテストするのに適している。',
    code_example: <<~'RUBY',
      # test/integration/user_flows_test.rb
      require "test_helper"

      class UserFlowsTest < ActionDispatch::IntegrationTest
        test "ログインして投稿を作成できる" do
          # ログイン
          post sessions_url, params: { email: "alice@example.com", password: "password" }
          assert_response :redirect
          follow_redirect!
          assert_response :success

          # 投稿作成
          assert_difference "Post.count", 1 do
            post posts_url, params: { post: { title: "Hello", body: "World" } }
          end
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'システムテスト',
    description: '実際のブラウザを操作して画面全体の動作を検証するテスト。Capybaraを使い、JavaScriptの動作も含めたE2Eテストができる。test/system/配下に置く。rails generate system_testで生成する。',
    code_example: <<~'RUBY',
      # test/system/users_test.rb
      require "application_system_test_case"

      class UsersTest < ApplicationSystemTestCase
        test "ユーザーを作成できる" do
          visit new_user_url

          fill_in "名前", with: "Alice"
          fill_in "メールアドレス", with: "alice@example.com"
          click_button "登録する"

          assert_text "ユーザーを作成しました"
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'システムテスト設定オプション',
    description: 'システムテストのブラウザやスクリーンサイズを設定するメソッド。test/application_system_test_case.rbのdriven_byで設定する。スクリーンショットも撮れる。',
    code_example: <<~'RUBY',
      # test/application_system_test_case.rb
      require "test_helper"

      class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
        # ヘッドレスChromiumを使う場合
        driven_by :selenium, using: :headless_chrome,
                  screen_size: [1400, 1400]

        # 通常のChromeを使う場合（画面が表示される）
        driven_by :selenium, using: :chrome

        # Capybaraのデフォルトドライバーを使う場合
        driven_by :rack_test
      end

      # テスト内でスクリーンショットを撮る
      # take_screenshot
    RUBY
    level: 2
  },
  {
    term: 'fixture_file_upload',
    description: 'ファイルアップロードをテストするためのヘルパーメソッド。test/fixtures/files/配下のファイルをアップロード用のオブジェクトとして生成する。',
    code_example: <<~'RUBY',
      # test/fixtures/files/sample.png を用意しておく
      test "アバター画像をアップロードできる" do
        file = fixture_file_upload("sample.png", "image/png")

        patch user_url(@user), params: {
          user: { avatar: file }
        }

        assert_response :redirect
        assert @user.reload.avatar.attached?
      end
    RUBY
    level: 2
  },
  {
    term: 'assert_enqueued_jobs',
    description: 'Active Jobのテストで、ブロック内でキューに追加されたジョブの件数を検証するアサーション。関連：assert_enqueued_with（特定のジョブがキューに追加されたか検証）。',
    code_example: <<~'RUBY',
      test "ユーザー登録でメール送信ジョブが追加される" do
        assert_enqueued_jobs 1 do
          post users_url, params: { user: valid_attributes }
        end

        # 特定のジョブを検証
        assert_enqueued_with(job: SendWelcomeEmailJob) do
          post users_url, params: { user: valid_attributes }
        end
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'assert_emails',
    description: 'Action Mailerのテストで、ブロック内で送信されたメールの件数を検証するアサーション。関連：assert_no_emails（メールが送信されないことを検証）、assert_enqueued_emails（非同期送信のメール件数を検証）、assert_enqueued_email_with（特定のメーラーメソッドでキューに追加されたことを検証）、assert_no_enqueued_emails（非同期メールが送信されないことを検証）。',
    code_example: <<~'RUBY',
      test "ユーザー登録でウェルカムメールが送信される" do
        assert_emails 1 do
          post users_url, params: { user: valid_attributes }
        end
      end

      test "無効な登録ではメールが送信されない" do
        assert_no_emails do
          post users_url, params: { user: invalid_attributes }
        end
      end

      # 非同期送信の検証
      assert_enqueued_emails 1 do
        UserMailer.welcome(@user).deliver_later
      end

      assert_enqueued_email_with UserMailer, :welcome, args: [@user] do
        UserMailer.welcome(@user).deliver_later
      end
    RUBY
    level: 3
  },
  {
    term: 'assert_broadcasts',
    description: 'Action Cableのテストで、特定のストリームへのブロードキャストを検証するアサーション。関連：assert_no_broadcasts（ブロードキャストされないことを検証）、assert_broadcast_on（特定のチャンネル・データでブロードキャストされたことを検証）。',
    code_example: <<~'RUBY',
      test "メッセージ作成でブロードキャストされる" do
        assert_broadcasts "chat_room_1", 1 do
          post messages_url, params: { message: { content: "Hello" } }
        end

        # ブロードキャストされないことを検証
        assert_no_broadcasts "chat_room_1" do
          post messages_url, params: { message: { content: "" } }
        end

        # 特定のデータでブロードキャストされたことを検証
        assert_broadcast_on(
          ChatChannel.broadcasting_for(@room),
          { message: "Hello", user: "Alice" }
        ) do
          ChatChannel.broadcast_to(@room, { message: "Hello", user: "Alice" })
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'assert_routing',
    description: 'ルーティングの設定が正しいことを検証するアサーション。URLとコントローラー・アクションの対応関係を確認する。関連：assert_generates（URLの生成を検証）、assert_recognizes（URLの認識を検証）。',
    code_example: <<~'RUBY',
      # URLとコントローラー・アクションの対応を検証
      assert_routing "/users",
        { controller: "users", action: "index" }

      assert_routing({ method: :post, path: "/users" },
        { controller: "users", action: "create" })

      # URLの生成を検証
      assert_generates "/users/1",
        { controller: "users", action: "show", id: "1" }

      # URLの認識を検証
      assert_recognizes(
        { controller: "users", action: "show", id: "1" },
        "/users/1"
      )
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
