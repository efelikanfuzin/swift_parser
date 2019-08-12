require 'swift_parser/version'
require 'strscan'

module SwiftParser
  class Base
    attr_reader :tags

    def initialize(str)
      @buffer = StringScanner.new(str.delete("\n"))
      @blocks = {}
      @last_tag_name = nil
    end
    
    def parse
      until @buffer.eos? || next_char_is?("}")
        @blocks.merge!(find_block)
      end
      
      @blocks
    end
    
    def find_block
      { find_block_name => find_block_content }
    end

    def find_block_name
      @buffer.scan_until(/:/).tr('{:', '')
    end

    def find_block_content
      return @buffer.scan_until(/}/).tr('}', '') unless next_char_is?('{')

      content = {}
      while next_char_is?('{')
        content.merge!(find_block)
      end

      content
    end

    def next_char_is?(char)
      @buffer.check(/#{char}/) == char
    end
  end
end
