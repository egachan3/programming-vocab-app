# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 大カテゴリ（LargeCategory）を取得または作成する。既に存在する場合はそのレコードを返す
@ruby_category = LargeCategory.find_or_create_by!(name: "Ruby")
@rails_category = LargeCategory.find_or_create_by!(name: "Rails")

# db/seeds/ruby/ 配下の .rb ファイルをファイル名順に取得し、1つずつ読み込んで実行する
Dir[Rails.root.join("db/seeds/ruby/*.rb")].sort.each do |file|
  load file
end

# db/seeds/rails/ 配下の .rb ファイルをファイル名順に取得し、1つずつ読み込んで実行する
Dir[Rails.root.join("db/seeds/rails/*.rb")].sort.each do |file|
  load file
end
