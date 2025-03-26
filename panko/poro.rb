# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem "panko_serializer"
end

# require 'panko_serializer'

class User
  attr_reader :id, :name, :email

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end
end

class UserSerializer < Panko::Serializer
  attributes :id, :name, :email
end

user = User.new(1, "Alice", "alice@example.com")
puts UserSerializer.new.serialize(user)