$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "swift_parser"

require "minitest/autorun"
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(color: true)]
