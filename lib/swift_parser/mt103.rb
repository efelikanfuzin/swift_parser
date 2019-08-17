# frozen_string_literal: true

module SwiftParser
  class Mt103
    attr_reader :swift_hash

    def initialize(swift_hash)
      @swift_hash = swift_hash
    end

    def to_h
      swift_hash
    end

    def sender_reference
      swift_hash.dig('4', '20')&.first
    end

    def bank_operation_code
      swift_hash.dig('4', '23B')&.first
    end

    def message_type
      swift_hash.dig('2')&.slice(1..3)
    end

    def date_currency_amount
      swift_hash.dig('4', '32A')&.first
    end
  end
end
