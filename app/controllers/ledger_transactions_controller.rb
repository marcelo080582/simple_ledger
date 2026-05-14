class LedgerTransactionsController < ApplicationController
  def create
    result = LedgerTransactions::CreateService.new(
      name: transaction_params[:name],
      entries_attributes: entries_attributes
    ).call

    if result.success?
      redirect_to root_path, notice: "Transaction created successfully."
    else
      redirect_to root_path, alert: result.errors.join(", ")
    end
  end

  private

  def transaction_params
    params.require(:ledger_transaction).permit(
      :name,
      :signature,
      entries_attributes: [
        :account_id,
        :direction,
        :amount_cents
      ]
    )
  end

  def entries_attributes
    transaction_params[:entries_attributes].map do |entry|
      entry.to_h.with_indifferent_access
    end
  end
end
