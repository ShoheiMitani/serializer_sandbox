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

  view :render_credential do
    fields :email
  end
end

user = User.new(1, "Alice", "alice@example.com")
puts UserBlueprint.render(user)
puts UserBlueprint.render(user, view: :render_credential)