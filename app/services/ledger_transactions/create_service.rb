require "digest"

module LedgerTransactions
  class CreateService
    DUPLICATE_WINDOW = 60.seconds

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
      prevent_duplicate_transaction!

      ledger_transaction = create_ledger_transaction!

      success_result(ledger_transaction)
    rescue StandardError => e
      failure_result([e.message])
    end

    private

    attr_reader :name, :entries_attributes

    def total_for(direction)
      entries_attributes.select { |entry| entry[:direction] == direction }.sum { |entry| entry[:amount_cents].to_i }
    end

    def debit_total
      total_for('debit')
    end

    def credit_total
      total_for('credit')
    end

    def distinct_accounts?
      account_ids = entries_attributes.map { |entry| entry[:account_id] }

      account_ids.uniq.size > 1
    end

    def balanced?
      debit_total == credit_total
    end

    def normalized_entries
      entries_attributes.map do |entry|
        {
          account_id: entry[:account_id].to_i,
          direction: entry[:direction],
          amount_cents: entry[:amount_cents].to_i
        }
      end.sort_by do |entry|
        [
          entry[:account_id],
          entry[:direction],
          entry[:amount_cents]
        ]
      end
    end

    def signature_payload
      {
        name: name,
        entries: normalized_entries
      }
    end

    def transaction_signature
      @transaction_signature ||= Digest::SHA256.hexdigest(
        signature_payload.to_json
      )
    end

    def create_entries!(ledger_transaction)
      entries_attributes.each do |entry|
        ledger_transaction.entries.create!(
          account_id: entry[:account_id],
          direction: entry[:direction],
          amount_cents: entry[:amount_cents]
        )
      end
    end

    def duplicate_transaction?
      LedgerTransaction.exists?(
        signature: transaction_signature,
        created_at: DUPLICATE_WINDOW.ago..Time.current
      )
    end

    def validate_entries!
      raise LedgerErrors::MinimumEntriesRequired, "Transaction must have at least two entries" if entries_attributes.size < 2

      raise LedgerErrors::SameAccountEntries, "Transaction must use different accounts" unless distinct_accounts?

      raise LedgerErrors::UnbalancedTransaction, "Debits and credits must be equal" unless balanced?
    end

    def prevent_duplicate_transaction!
      return unless duplicate_transaction?

      raise LedgerErrors::DuplicateTransaction, "Duplicate transaction detected within 60 seconds"
    end

    def create_ledger_transaction!
      ActiveRecord::Base.transaction do
        LedgerTransaction.create!(name: name, signature: transaction_signature).tap do |ledger_transaction|
          create_entries!(ledger_transaction)
        end
      end
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
  end
end
