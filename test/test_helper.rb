$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'language_cards'
require 'minitest/autorun'
require_relative 'support'

class Minitest::Test
  include Support
end
