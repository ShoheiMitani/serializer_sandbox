# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'rails', '~> 8.0'
  gem 'sqlite3'
  gem "alba"
end

require 'alba'
require 'active_record'

# データベース設定
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# マイグレーション
ActiveRecord::Schema.define do
  create_table :fuga_users do |t|
    t.timestamps
  end

  create_table :fuga_articles do |t|
    t.references :fuga_user, foreign_key: true
    t.string :title
    t.text :body
    t.timestamps
  end
end

# Railsのデフォルトのエンコーダーと互換性を持たせる
Alba.backend = :active_support
Alba.inflector = :active_support

class TestApp < Rails::Application
  config.load_defaults Rails::VERSION::STRING.to_f
  config.eager_load = false
  config.logger = Logger.new($stdout)
  config.secret_key_base = "secret_key_base"
end

Rails.application.initialize!

module Fuga
  def self.table_name_prefix
    'fuga_'
  end

  class User < ActiveRecord::Base
    has_many :articles, class_name: 'Fuga::Article', foreign_key: :fuga_user_id
  end

  class Article < ActiveRecord::Base
    belongs_to :user, class_name: 'Fuga::User', foreign_key: :fuga_user_id
  end

  class ArticleSerializer
    include Alba::Resource
  
    attributes :title
  end
  
  class UserSerializer
    include Alba::Resource
  
    attributes :id
  
    many :articles, key: :sample_articles, serializer: ArticleSerializer, if: proc { true }
  end
end

# テストデータの作成
user = Fuga::User.create!
article1 = user.articles.create!(title: 'Hello World!', body: 'Hello World!!!')
article2 = user.articles.create!(title: 'Super nice', body: 'Really nice!')

pp Fuga::UserSerializer.new(user).serialize
