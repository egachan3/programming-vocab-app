# Rails - アクティブジョブに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'アクティブジョブ', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'perform_later',
    description: 'ジョブをキューに追加して非同期で実行するクラスメソッド。引数はperformメソッドにそのまま渡される。バックグラウンドで時間のかかる処理を行うときに使う。',
    code_example: <<~'RUBY',
      # ジョブクラスの定義
      class SendWelcomeEmailJob < ApplicationJob
        queue_as :default

        def perform(user)
          UserMailer.welcome(user).deliver_now
        end
      end

      # ジョブをキューに追加
      SendWelcomeEmailJob.perform_later(user)

      # 実行を遅らせる場合
      SendWelcomeEmailJob.set(wait: 10.minutes).perform_later(user)
    RUBY
    level: 1
  },
  {
    term: 'perform_now',
    description: 'ジョブを即座に同期的に実行するクラスメソッド。キューに追加せずその場で実行する。テストやデバッグ、即時実行が必要な場合に使う。',
    code_example: <<~'RUBY',
      SendWelcomeEmailJob.perform_now(user)
      # キューに追加せず、その場で同期的に実行される
    RUBY
    level: 1
  },
  {
    term: 'queue_as',
    description: 'ジョブを追加するキュー名を指定するクラスメソッド。キューを分けることで優先度や処理サーバーを使い分けられる。',
    code_example: <<~'RUBY',
      class SendEmailJob < ApplicationJob
        queue_as :mailers
      end

      class GenerateReportJob < ApplicationJob
        queue_as :low_priority
      end

      # ブロックで動的に指定
      class ProcessImageJob < ApplicationJob
        queue_as do
          user.premium? ? :high_priority : :default
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'retry_on',
    description: '指定した例外が発生したときにジョブをリトライするクラスメソッド。試行回数・待機時間・バックオフ戦略を指定できる。',
    code_example: <<~'RUBY',
      class SendEmailJob < ApplicationJob
        retry_on Net::OpenTimeout, wait: 5.seconds, attempts: 3
        retry_on ActiveRecord::Deadlocked, wait: :polynomially_longer, attempts: 5

        def perform(user)
          UserMailer.welcome(user).deliver_now
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'discard_on',
    description: '指定した例外が発生したときにリトライせずジョブを破棄するクラスメソッド。存在しないレコードへの処理など、リトライしても無意味な場合に使う。',
    code_example: <<~'RUBY',
      class SendEmailJob < ApplicationJob
        discard_on ActiveRecord::RecordNotFound
        discard_on ActiveJob::DeserializationError

        def perform(user)
          UserMailer.welcome(user).deliver_now
        end
      end
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'set',
    description: 'ジョブの実行オプション（待機時間・キュー・優先度など）を指定するクラスメソッド。perform_laterの前にチェーンして使う。',
    code_example: <<~'RUBY',
      # 10分後に実行
      SendEmailJob.set(wait: 10.minutes).perform_later(user)

      # 指定日時に実行
      SendEmailJob.set(wait_until: Date.tomorrow.noon).perform_later(user)

      # キューと優先度を指定
      SendEmailJob.set(queue: :urgent, priority: 10).perform_later(user)
    RUBY
    level: 2
  },
  {
    term: 'before_perform',
    description: 'ジョブのperformメソッドが実行される前に処理を行うコールバック。ログの記録や前処理に使う。',
    code_example: <<~'RUBY',
      class ApplicationJob < ActiveJob::Base
        before_perform do |job|
          logger.info "ジョブ開始: #{job.class.name} (#{job.job_id})"
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'after_perform',
    description: 'ジョブのperformメソッドが実行された後に処理を行うコールバック。後処理やログの記録に使う。',
    code_example: <<~'RUBY',
      class ApplicationJob < ActiveJob::Base
        after_perform do |job|
          logger.info "ジョブ完了: #{job.class.name} (#{job.job_id})"
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'around_perform',
    description: 'ジョブのperformメソッドの前後を囲んで処理を行うコールバック。処理時間の計測やトランザクション管理に使う。',
    code_example: <<~'RUBY',
      class ApplicationJob < ActiveJob::Base
        around_perform do |job, block|
          start = Time.current
          block.call
          elapsed = Time.current - start
          logger.info "処理時間: #{elapsed}秒"
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'before_enqueue',
    description: 'ジョブがキューに追加される前に処理を行うコールバック。エンキュー前のバリデーションや前処理に使う。',
    code_example: <<~'RUBY',
      class SendEmailJob < ApplicationJob
        before_enqueue do |job|
          logger.info "エンキュー: #{job.arguments}"
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'job_id',
    description: 'ジョブインスタンスごとに割り当てられる一意なID（UUID）を返すメソッド。ジョブの追跡やログ管理に使う。',
    code_example: <<~'RUBY',
      job = SendEmailJob.perform_later(user)
      job.job_id
      # => "7d7b2878-d22e-41c9-b34e-a17cf372b5f0"
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'queue_name',
    description: 'ジョブインスタンスのキュー名を返すメソッド。queue_asで設定した値が返される。',
    code_example: <<~'RUBY',
      job = SendEmailJob.new
      job.queue_name   # => "mailers"
    RUBY
    level: 3
  },
  {
    term: 'priority',
    description: 'ジョブの優先度を取得・設定するメソッド。数値が小さいほど優先度が高い。キューアダプターが対応している場合に有効。',
    code_example: <<~'RUBY',
      class UrgentJob < ApplicationJob
        queue_with_priority 1
      end

      class LowPriorityJob < ApplicationJob
        queue_with_priority 100
      end

      job = UrgentJob.new
      job.priority   # => 1
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
