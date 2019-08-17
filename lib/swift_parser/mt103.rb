# frozen_string_literal: true

module SwiftParser
  class Mt103
    attr_reader :swift_hash

    ATTRIBUTE_NAMES = [
      { name: :sender_reference,               path: '20'  },
      { name: :bank_operation_code,            path: '23B' },
      { name: :date_currency_amount,           path: '32A' },
      { name: :currency_amount,                path: '33B' },
      { name: :ordering_customer,              path: '50K' },
      { name: :ordering_institution,           path: '52A' },
      { name: :sender_correspondent,           path: '53B' },
      { name: :beneficiary_bank,               path: '57A' },
      { name: :beneficiary,                    path: '59'  },
      { name: :remittance_information,         path: '70'  },
      { name: :details_of_charges,             path: '71A' },
      { name: :sender_to_receiver_information, path: '72'  }
    ].freeze

    def initialize(swift_hash)
      @swift_hash = swift_hash
    end

    def to_h
      swift_hash
    end

    ATTRIBUTE_NAMES.each do |attribute|
      define_method(attribute[:name]) do
        swift_hash.dig('4', attribute[:path])&.join(' ')
      end
    end

    def message_type
      swift_hash.dig('2')&.slice(1..3)
    end
  end
end
