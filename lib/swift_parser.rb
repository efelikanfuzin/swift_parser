# frozen_string_literal: true

require 'swift_parser/version'
require 'strscan'

module SwiftParser
  class InvalidSwift < StandardError; end

  class Base
    attr_reader :blocks, :buffer

    def initialize(str)
      @buffer = StringScanner.new(str)
      @blocks = {}
    end

    def parse!
      until buffer.eos?
        blocks.merge!(find_block)

        close_brackets!
      end

      blocks
    rescue StandardError
      raise InvalidSwift
    end

    def parse
      parse!
    rescue InvalidSwift
      {}
    end

    private

    def find_block
      { find_block_name => find_block_content }
    end

    def find_block_name
      buffer.scan_until(/:/).tr('{}:', '')
    end

    def find_block_content
      return tag_content unless more_blocks?

      content = {}
      content.merge!(find_block) while more_blocks?

      content
    end

    def tag_content
      tag_content = buffer.scan_until(/\}/).sub('-}', '').sub('}', '')

      content_have_attrs?(tag_content) ? parse_attrs(tag_content) : tag_content
    end

    def close_brackets!
      buffer.scan(/\}/)
    end

    def more_blocks?
      buffer.check(/\{/) != nil
    end

    def content_have_attrs?(content)
      content.include?(':')
    end

    def parse_attrs(string)
      string.split(':')
            .reject { |item| blank_string?(item) }
            .each_slice(2)
            .each_with_object({}) { |(k, v), hsh| hsh[k] = v.strip.split("\n") }
    end

    def blank_string?(str)
      ['', ' ', nil, "\n"].include?(str)
    end
  end
end
