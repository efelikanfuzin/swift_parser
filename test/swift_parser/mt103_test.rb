# frozen_string_literal: true

require 'test_helper'

module SwiftParser
  class Mt103Test < Minitest::Test
    def setup
      swift_hash = {
        '2' => 'O1030919010321BBBBGRA0AXXX00570001710103210920N',
        '4' => {
          '20' => ['MOSTJSC5123403DB'],
          '23B' => ['CRED'],
          '32A' => ['180425CNY5355,'],
          '33B' => ['CNY5355,'],
          '50K' => [
            '/305160034498',
            'SYM HOIST AND TOWER CRANE EQUIPMENT',
            'CO., LTD. ADD.ROOM 843, 81 PANGJIA',
            'NG STREET DADONG DISTRICT, SHENYANG',
            ', CHINA, CHINA'
          ],
          '52A' => ['BKCHCNBJ82A'],
          '53B' => ['/C/30109156800000000174'],
          '57A' => ['BELERUA1TCH'],
          '59' => [
            '/40702156710050000003',
            'OOO KRANTEHPRO 2801224221 ADD.UL B.',
            'HMELNICKOGO,DOM 42,OF 404, G BLAGOV',
            'ESHENSK, RUSSIA'
          ],
          '70' => [
            '/RETN/C18041902630012H /ETE/MSCICB0',
            '5116285DB YR.REF.180419.8447'
          ],
          '71A' => ['SHA'],
          '72' => [
            '/ACC/DUE TO THE CANCELLATION OF CO-',
            '//NTRACT',
            '/INS/ICBKRUMMCLR'
          ]
        }
      }
      @mt103 = SwiftParser::Mt103.new(swift_hash)
    end

    def test_sender_reference
      assert_equal 'MOSTJSC5123403DB', @mt103.sender_reference
    end

    def test_bank_operation_code
      assert_equal 'CRED', @mt103.bank_operation_code
    end

    def test_message_type
      assert_equal '103', @mt103.message_type
    end

    def test_date_currency_amount
      assert_equal '180425CNY5355,', @mt103.date_currency_amount
    end

    def test_currency_amount
      assert_equal 'CNY5355,', @mt103.currency_amount
    end

    def test_ordering_customer
      assert_equal(
        '/305160034498 SYM HOIST AND TOWER CRANE EQUIPMENT CO., LTD. ' \
        'ADD.ROOM 843, 81 PANGJIA NG STREET DADONG DISTRICT, SHENYANG CHINA, CHINA',
        @mt103.ordering_customer
      )
    end

    def test_ordering_institution
      assert_equal 'BKCHCNBJ82A', @mt103.ordering_institution
    end

    def test_sender_correspondent
      assert_equal '/C/30109156800000000174', @mt103.sender_correspondent
    end

    def test_beneficiary_bank
      assert_equal 'BELERUA1TCH', @mt103.beneficiary_bank
    end

    def test_beneficiary
      assert_equal(
        '/40702156710050000003 OOO KRANTEHPRO 2801224221 ADD.UL ' \
        'B. HMELNICKOGO,DOM 42,OF 404, G BLAGOV ESHENSK, RUSSIA',
        @mt103.beneficiary
      )
    end

    def test_remittance_information
      assert_equal(
        '/RETN/C18041902630012H /ETE/MSCICB0 5116285DB YR.REF.180419.8447',
        @mt103.remittance_information
      )
    end

    def test_details_of_charges
      assert_equal 'SHA', @mt103.details_of_charges
    end

    def test_sender_to_receiver_information
      assert_equal(
        '/ACC/DUE TO THE CANCELLATION OF CO- //NTRACT /INS/ICBKRUMMCLR',
        @mt103.sender_to_receiver_information
      )
    end
  end
end
