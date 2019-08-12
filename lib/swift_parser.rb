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
      return tag_content unless has_more_blocks?

      content = {}
      while has_more_blocks?
        content.merge!(find_block)
      end

      content
    end

    def tag_content
      @buffer.scan_until(/}/).tr('}', '')
    end

    def close_brackets!
      @buffer.scan(/\}+/)
    end

    def has_more_blocks?
      @buffer.check(/\{/) != nil
    end
  end
end
