# デプロイ・データベース構成

## 概要

| 項目 | 内容 |
|---|---|
| アプリ本体のデプロイ先 | [Render](https://render.com)(無料プラン) |
| データベース | [Supabase](https://supabase.com)(無料プラン、PostgreSQL) |
| Renderの休止対策 | UptimeRobot等の外部監視サービスによる定期ping |
| Supabaseの休止対策 | GitHub Actions定期実行(`.github/workflows/keep-alive.yml`) |

## 背景・移行理由

当初はRenderの無料PostgreSQLをそのまま利用していたが、Renderの無料DBは**アクセスの有無に関わらず作成から一定日数(30〜90日程度)で自動削除される**仕様だった。実際にこの制限により、既存のDBへの接続が切れて`db:migrate`を含むビルドが失敗する障害が発生した(2026-07-30)。

このアプリは学習用・ポートフォリオ用途で、データの永続性よりも「アクセス時に常に正常に動作する状態を維持する」ことを優先したため、以下の構成に移行した。

## DB移行先の比較検討

| サービス | 休止・削除の条件 | 復帰方法 |
|---|---|---|
| Render無料Postgres | アクセス有無に関わらず経過日数で自動削除。定期pingでは回避不可 | 削除後は復旧不可 |
| **Supabase無料(採用)** | 7日間無アクセスでプロジェクト全体が一時停止。リクエスト毎のコールドスタートはない | 定期pingで一時停止自体を防げる |
| Neon無料 | 約5分無アクセスでcomputeがサスペンド(データは消えない) | アクセス時に自動復帰するが毎回起動待ちが発生する |
| CockroachDB Serverless無料 | 時間経過での休止なし | 常時起動扱い |

Supabaseを採用した理由: リクエスト単位のコールドスタートがなく常時ウォームなため、「起動待ちなくいつでも正常に見せたい」というポートフォリオ用途に合致する。7日間の完全無アクセスさえ防げれば実質常時起動を維持できる。

## Supabaseとの接続方法

- RailsはActiveRecord経由で直接PostgreSQLに接続する(`supabase-js`やSupabaseのData API/PostgREST機能は使用しない)
- 接続方式は **Session pooler**(ポート5432、IPv4)を使用。Renderの外向き通信がIPv4のみのため、IPv6前提のDirect connectionは利用できない。ActiveRecordは接続を永続的に保持するため、トランザクション単位で使い回すTransaction poolerよりSession poolerが適している
- Supabaseプロジェクトの「Data API」は無効化している。Rails側でDeviseによる認証・認可を行っており、Data API(自動生成REST API)を有効にすると認証をすり抜けてテーブルに直接アクセスできる経路が公開されてしまうため

## Renderの設定変更

`render.yaml`から`databases:`セクション(Render管理DBの自動プロビジョニング)を削除し、`DATABASE_URL`を`fromDatabase`による自動取得から手動設定の秘匿環境変数(`sync: false`)に変更した。実際の値(Supabaseの接続文字列)はRenderダッシュボードの環境変数で設定する。

## 定期ping(keep-alive)の仕組み

当初はRenderへのアクセスとSupabaseへのDBクエリの両方をGitHub Actionsの`*/10`(10分おき)cronで実行していたが、**実際には1時間以上スケジュール実行が発生しないことがあった**。GitHub Actionsのscheduleイベントは負荷分散のため実行タイミングを保証しておらず、高頻度なcronほど遅延・間引きされやすい。Renderの無料枠は15分でスリープするため、この遅延幅では間に合わず、実際にコールドスタート(ロード画面)が発生した。

この実測を踏まえ、以下のように役割を分離した。

1. **Renderアプリへのping(15分以内が必須)**: [UptimeRobot](https://uptimerobot.com)等、HTTP監視に特化した外部サービスで行う。5分間隔で監視でき、GitHub Actionsのような間引きが起きにくい。設定はUptimeRobotのダッシュボード上で行うため、このリポジトリのコードには現れない
2. **SupabaseのDBへのクエリ実行(7日以内でよい)**: 引き続き`.github/workflows/keep-alive.yml`(GitHub Actions、30分おきcron)で`psql`により`SELECT 1`を実行する。7日間という猶予があるため、GitHub Actionsの遅延・間引きが多少発生しても実用上問題ない。接続文字列はGitHub Secretsの`SUPABASE_DB_URL`に登録している

このリポジトリはパブリックリポジトリのため、GitHub Actionsの実行時間は無料・無制限で消費される。プライベートリポジトリの場合はping頻度によっては無料枠(月2,000分)を超過する可能性がある点に注意。

> [!note] GitHub Actionsのcronを15分未満の間隔が必要な用途に使わない
> 高頻度スケジュール実行はGitHub側で確実性を保証されていない。15分のような短いしきい値に対する定期pingには、UptimeRobotのような監視専用サービスを使う方が確実。

## 検討したが採用しなかった選択肢

**Cloudflare (Workers/D1/R2) フルスタック構成**: Cloudflare Workersはサーバー常駐という概念がなく、リクエスト毎にV8 isolateを数ミリ秒で起動するため起動待ちの問題を原理的に解消できる。ただしJavaScript/TypeScript前提の実行環境で、Ruby on Railsはネイティブでは動かないため、アプリ全体の書き換えが必要になり見送った。
