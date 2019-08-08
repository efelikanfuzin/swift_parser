require 'test_helper'
require 'pry'

class SwiftParserTest < Minitest::Test
  def setup
    @parser_class = SwiftParser::Base
  end

  def test_simplest_example
    skip
    swift_file = '{1:F01BELERUMMA}{2:O1031386941804251314N}'
    exp_ast = { '1' => 'F01BELERUMMA', '2' => 'O1031386941804251314N' }

    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end

  def test_simplest_example_2
    swift_file = '{1:{2:F01}{3:O1031}}{2:TEST}'
    exp_ast = { '1' => { '2' => 'F01', '3' => 'O1031' }, '2' => 'TEST' }
    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end

  def test_nested_tags
    skip
    swift_file = '{1:{2:{4:32}{23A:TEST}}}'
    exp_ast = \
      {
        '1' => {
          '2' => {
            '4'   => '32',
            '23A' => 'TEST'
          }
        }
      }
    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end

  def test_simple_part_of_swift_file
    skip
    swift_file = \
      '{1:F01BELERUMMAXXX3987291980}'\
      '{2:O1031314180425TJSCRUMMAXXX62506386941804251314N}'
    exp_ast = [
      { name: '1', content: ['F01BELERUMMAXXX3987291980'] },
      { name: '2', content: ['O1031314180425TJSCRUMMAXXX62506386941804251314N'] }
    ]
    assert_equal exp_ast, @parser.new(swift_file).parse.map(&:inspect)
  end

  def test_nested_tags_in_swift_file
    skip
    swift_file =
      '{5:{MAC:00000000}{CHK:442B6311EC3F}}'\
      '{S:{SAC:}{COP:S}{LAU:95E078FB}}'
    exp_ast = {
      '5' => { 'MAC' => '00000000', 'CHK' => '442B6311EC3F' },
      'S' => { 'SAC' => '', 'COP' => 'S', 'LAU' => '95E078FB' }
    }
    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end

  def test_tag_with_attributes
    skip
    swift_file = \
      "{1:BELERUMMAX}{2:O103131}{4:\n" \
      ":20:MOSTJSC5123403DB\n" \
      ":23B:CRED\n" \
      ":33B:CNY5355,\n" \
      '-}{5:{MAC:00000000}{CHK:442B6311EC3F}}{S:{SAC:}{COP:S}{LAU:95E078FB}}'
    exp_ast = [
      { name: '1', content: ['BELERUMMAX'] },
      { name: '2', content: ['O103131'] },
      {
        name: '4',
        content: [
          { name: '20', content: ['MOSTJSC5123403DB'] },
          { name: '23B', content: ['CRED'] },
          { name: '33B', content: ['CNY5355,'] }
        ]
      },
      {
        name: '5',
        content: [
          { name: 'MAC', content: ['00000000']},
          { name: 'CHK', content: ['442B6311EC3F']}
        ]
      },
      {
        name: 'S',
        content: [
          { name: 'SAC', content: [''] },
          { name: 'COP', content: ['S'] },
          { name: 'LAU', content: ['95E078FB'] }
        ]
      }
    ]
    assert_equal exp_ast, @parser.new(swift_file).parse.map(&:inspect)
  end

  def test_multiline_attributes
    skip
    swift_file = \
      "{1:BELERUMMAX}{2:O103131}{4:\n" \
      ":50K:/305160034498\n" \
      "SYM HOIST AND TOWER CRANE EQUIPMENT\n" \
      "CO., LTD. ADD.ROOM 843, 81 PANGJIA\n" \
      "NG STREET DADONG DISTRICT, SHENYANG\n" \
      ", CHINA, CHINA\n" \
      ":59:/40702156710050000003\n" \
      "OOO KRANTEHPRO 2801224221 ADD.UL B.\n" \
      "HMELNICKOGO,DOM 42,OF 404, G BLAGOV\n" \
      "ESHENSK, RUSSIA\n" \
      '-}'
    exp_ast = [
      { name: '1', content: ['BELERUMMAX'] },
      { name: '2', content: ['O103131'] },
      {
        name: '4',
        content: [
          {
            name: '50K',
            content: [
              '/305160034498',
              'SYM HOIST AND TOWER CRANE EQUIPMENT',
              'CO., LTD. ADD.ROOM 843, 81 PANGJIA',
              'NG STREET DADONG DISTRICT, SHENYANG',
              ', CHINA, CHINA'
            ]
          },
          {
            name: '59',
            content: [
              '/40702156710050000003',
              'OOO KRANTEHPRO 2801224221 ADD.UL B.',
              'HMELNICKOGO,DOM 42,OF 404, G BLAGOV',
              'ESHENSK, RUSSIA'
            ]
          }
        ]
      }
    ]
    assert_equal exp_ast, @parser_class.new(swift_file).parse
  end
end
