# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem 'rails', '~> 8.0'

  gem "alba"
  gem "rspec"
end

require 'alba'

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

class User
  attr_accessor :id, :name, :email

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end
end

class UserResource
  include Alba::Resource

  root_key :user

  attributes :id

  attribute :name do |user|
    params[:upcase] ? user.name.upcase : user.name
  end

  attribute :name_with_email do |resource|
    "#{resource.name}: #{resource.email}"
  end
end


# テストケースの定義
describe "BugTest" do
  it "should pass" do
    user = User.new(1, 'Masafumi OKURA', 'masafumi@example.com')
    serialized = UserResource.new(user, params: {upcase: true}).serialize

    json = JSON.parse(serialized)
    expect(json['user']['id']).to eq 1
    expect(json['user']['name']).to eq 'MASAFUMI OKURA'
    expect(json['user']['name_with_email']).to eq 'Masafumi OKURA: masafumi@example.com'
  end
end

# RSpecの実行
RSpec::Core::Runner.run([])
