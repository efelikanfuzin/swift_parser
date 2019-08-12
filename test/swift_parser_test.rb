require 'test_helper'
require 'pry'

class SwiftParserTest < Minitest::Test
  def setup
    @parser_class = SwiftParser::Base
  end

  def test_simplest_example
    swift_file = '{1:F01BELERUMMA}{2:O1031386941804251314N}'
    exp_ast = { '1' => 'F01BELERUMMA', '2' => 'O1031386941804251314N' }

    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end

  def test_nested_blocks
    swift_file = '{5:{MAC:75D138E4}{CHK:DE1B0D71FA96}}'
    exp_ast = {
      '5' => {
        'MAC' => '75D138E4',
        'CHK' => 'DE1B0D71FA96'
      }
    }

    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end
end
