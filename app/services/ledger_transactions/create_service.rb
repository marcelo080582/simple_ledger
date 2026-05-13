module LedgerTransactions
  class CreateService
    Result = Struct.new(:success, :ledger_transaction, :errors, keyword_init: true) do
      def success?
        success
      end
    end

    def initialize(name:, entries_attributes:)
      @name = name
      @entries_attributes = entries_attributes
    end

    def call
      validate_entries!
      ledger_transaction = create_ledger_transaction!

      success_result(ledger_transaction)
    rescue StandardError => e
      failure_result([e.message])
    end

    private

    attr_reader :name, :entries_attributes

    def validate_entries!
      raise LedgerErrors::MinimumEntriesRequired, 'Transaction must have at least two entries' if entries_attributes.size < 2

      raise LedgerErrors::UnbalancedTransaction, 'Debits and credits must be equal' unless balanced?
    end

    def total_for(direction)
      entries_attributes.select { |entry| entry[:direction] == direction }.sum { |entry| entry[:amount_cents].to_i }
    end

    def debit_total
      total_for('debit')
    end

    def credit_total
      total_for('credit')
    end

    def balanced?
      debit_total == credit_total
    end

    def success_result(ledger_transaction)
      Result.new(
        success: true,
        ledger_transaction: ledger_transaction,
        errors: []
      )
    end

    def failure_result(errors)
      Result.new(
        success: false,
        ledger_transaction: nil,
        errors: errors
      )
    end

    def create_ledger_transaction!
      ActiveRecord::Base.transaction do
        LedgerTransaction.create!(name: name).tap do |ledger_transaction|
          entries_attributes.each do |attribute|
            ledger_transaction.entries.create!(
              account_id: attribute[:account_id],
              direction: attribute[:direction],
              amount_cents: attribute[:amount_cents]
            )
          end
        end
      end
    end
  end
end
