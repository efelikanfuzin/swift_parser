# frozen_string_literal: true

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
    swift_file = '{1:TEST}{5:{MAC:75D138E4}{CHK:{23B:DE1B0D71FA96}}{2:4323}'
    exp_ast = {
      '1' => 'TEST',
      '5' => {
        'MAC' => '75D138E4',
        'CHK' => { '23B' => 'DE1B0D71FA96' }
      },
      '2' => '4323'
    }

    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end

  def test_fourth_block
    swift_file = read_file('swift_sample.f06')
    exp_ast = {
      '20' => ['MOSTJSC5123403DB'],
      '23B' => ['CRED'],
      '32A' => ['180425CNY5355,'],
      '33B' => ['CNY5355,'],
      '50K' => [
        '/305160034498',
        'SYM HOIST AND TOWER CRANE EQUIPMENT',
        'CO., LTD. ADD.ROOM 843, 81 PANGJIA',
        'NG STREET DADONG DISTRICT, SHENYANG',
        ', CHINA, CHINA'
      ],
      '52A' => ['BKCHCNBJ82A'],
      '53B' => ['/C/30109156800000000174'],
      '57A' => ['BELERUA1TCH'],
      '59' => [
        '/40702156710050000003',
        'OOO KRANTEHPRO 2801224221 ADD.UL B.',
        'HMELNICKOGO,DOM 42,OF 404, G BLAGOV',
        'ESHENSK, RUSSIA'
      ],
      '70' => [
        '/RETN/C18041902630012H /ETE/MSCICB0',
        '5116285DB YR.REF.180419.8447'
      ],
      '71A' => ['SHA'],
      '72' => [
        '/ACC/DUE TO THE CANCELLATION OF CO-',
        '//NTRACT',
        '/INS/ICBKRUMMCLR'
      ]
    }

    assert_equal exp_ast, @parser_class.new(swift_file).parse['4']
  end

  def test_parse_empty_string
    assert_equal({} , @parser_class.new('').parse)
  end

  def test_raise_errors_with_wrong_type
    assert_raises(TypeError) { @parser_class.new(1321).parse }
    assert_raises(TypeError) { @parser_class.new({}).parse }
    assert_raises(TypeError) { @parser_class.new([1321]).parse }
  end

  def test_raise_errors_when_invalid_swift_structure
    binding.pry
    assert_raises(SwiftParser::InvalidSwift) { @parser_class.new('{1:no_close_brackets}}').parse }
  end
end
