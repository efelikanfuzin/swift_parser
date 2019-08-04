require 'swift_parser/version'
require 'strscan'

module SwiftParser
  class Base
    attr_reader :tags

    def initialize(str)
      @buffer = StringScanner.new(str.delete("\n"))
      @tags = {}
      @last_tag_name = nil
    end

    def parse
      until @buffer.eos?
        tag = find_tag
        binding.pry
        @tags.merge!(tag) if tag.is_a?(Hash)
      end
      @tags
    end

    def find_tag
      if new_tag?
        tag_name = find_tag_name
        content = @buffer.check(/{/) ? find_tag : find_tag_content

        { tag_name => content }
      else
        find_close_tag
      end
    end

    def new_tag?
      @buffer.scan(/{/)
    end

    def find_tag_name
      @buffer.scan_until(/:/).chop
    end

    def find_tag_content
      @buffer.scan_until(/}/).chop
    end

    def find_close_tag
      @buffer.scan(/}/)
    end
  end
end
