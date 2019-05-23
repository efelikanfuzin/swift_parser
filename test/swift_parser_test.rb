require 'test_helper'
require 'pry'

class SwiftParserTest < Minitest::Test
  def setup
    @parser = SwiftParser::Base
  end

  def test_simple_part_of_swift_file
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
    swift_file =
      '{5:{MAC:00000000}{CHK:442B6311EC3F}}'\
      '{S:{SAC:}{COP:S}{LAU:95E078FB}}'
    exp_ast = [
      {
        name: '5',
        content: [
          { name: 'MAC', content: ['00000000'] },
          { name: 'CHK', content: ['442B6311EC3F'] }
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

  def test_tag_with_attributes
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
end
