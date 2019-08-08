require 'swift_parser/version'
require 'strscan'

module SwiftParser
  class Base
    attr_reader :tags

    def initialize(str)
      @buffer = StringScanner.new(str.delete("\n"))
      @tags = {}
      @blocks = {}
      @last_tag_name = nil
    end

    def parse
      until @buffer.eos?
        @blocks.merge!(find_block)
      end

      @blocks
    end

    def find_block
      { find_block_name => find_block_content } # => { '1' => '1231' } or { '2' => { 'A23' => 'test' } }
    end

    def find_block_name
      @buffer.scan_until(/:/).tr('{:', '')
    end

    def find_block_content
      if next_char_is?('{')
        find_block
      else
        @buffer.scan_until(/}/)
      end
    end

    def next_char_is?(char)
      @buffer.check(/#{char}/) == char
    end
  end
end
