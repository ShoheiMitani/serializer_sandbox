# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem "blueprinter"
end

require 'blueprinter'

class User
  attr_reader :id, :name, :email

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end
end

class UserBlueprint < Blueprinter::Base
  # identifier :id
  fields :name

  field :name do |user, options|
    options[:upcase] ? user.name.upcase : user.name
  end

  field :name_with_email do |user|
    "#{user.name}: #{user.email}"
  end
end

user = User.new(1, "Alice", "alice@example.com")
puts UserBlueprint.render(user, upcase: true)