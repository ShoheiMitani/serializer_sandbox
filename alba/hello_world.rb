# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem "alba"
end

require 'alba'

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

  attributes :id, :name, :email
end


user = User.new(1, 'Masafumi OKURA', 'masafumi@example.com')
puts UserResource.new(user, params: {upcase: true}).serialize
