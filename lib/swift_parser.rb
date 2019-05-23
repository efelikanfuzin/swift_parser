require 'swift_parser/version'
require 'strscan'

module SwiftParser
  class Base
    attr_reader :tags

    def initialize(str)
      @buffer = StringScanner.new(str)
      @tags = []
    end

    def parse
      tags.push(find_tag) until @buffer.eos?
      tags
    end

    private

    def find_tag
      @buffer.scan_until(/{/)
      tag = Tag.new(@buffer.scan_until(/:/).chop)

      if tag.name == '4'
        @buffer.scan_until(/:(?<name>\d\d\w?):(.*)\s/)
      elsif @buffer.peep(1) == '{'
        tag.content << find_tag until @buffer.peep(1) == '}'
        @buffer.getch
      else
        tag.content << @buffer.scan_until(/}/).chop
      end

      tag
    end

    class Tag
      attr_reader :name
      attr_accessor :content

      def initialize(name)
        @name = name
        @content = []
      end

      def inspect
        {
          name: name,
          content: content.map { |item| item.is_a?(String) ? item : item.inspect }
        }
      end
    end
  end
end
