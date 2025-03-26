# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'rails', '~> 8.0'
  gem 'pg'
  gem "panko_serializer"
end

require 'active_record'

# データベース設定
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'panko_test',
  username: 'postgres',
  password: 'postgres',
  host: 'localhost'
)

# マイグレーション
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
    t.timestamps
  end
end

class TestApp < Rails::Application
  config.load_defaults Rails::VERSION::STRING.to_f
  config.eager_load = false
  config.logger = Logger.new($stdout)
  config.secret_key_base = "secret_key_base"
end

Rails.application.initialize!

class User < ActiveRecord::Base
end

class UserSerializer < Panko::Serializer
  attributes :name
end

# テストデータの作成
user = User.create!(name: 'Panko')

pp UserSerializer.new.serialize(User.first)
