# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'swift_parser'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(color: true)]

module Minitest
  class Test
    def read_file(name)
      File.read("test/fixtures/files/#{name}")
    end
  end
end
