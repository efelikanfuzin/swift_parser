require 'swift_parser/version'
require 'strscan'

module SwiftParser
  class Base
    attr_reader :tags

    def initialize(str)
      @buffer = StringScanner.new(str.delete("\n"))
      @blocks = {}
    end
    
    def parse
      until @buffer.eos?
        @blocks.merge!(find_block)

        close_brackets!
      end
      
      @blocks
    end

    private

    def find_block
      { find_block_name => find_block_content }
    end

    def find_block_name
      @buffer.scan_until(/:/).tr('{:', '')
    end

    def find_block_content
      return tag_content unless more_blocks?

      content = {}
      content.merge!(find_block) while more_blocks?

      content
    end

    def tag_content
      @buffer.scan_until(/}/).tr('}', '')
    end

    def close_brackets!
      @buffer.scan(/\}+/)
    end

    def more_blocks?
      @buffer.check(/\{/) != nil
    end
  end
end
