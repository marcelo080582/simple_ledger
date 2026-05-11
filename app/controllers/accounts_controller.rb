class AccountsController < ApplicationController
  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to root_path, notice: "Conta criada com sucesso."
    else
      redirect_to root_path, alert: @account.errors.full_messages.to_sentence
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :direction)
  end
end
