require "rails_helper"

RSpec.describe "Accounts", type: :request do
  describe "POST /accounts" do
    it "creates an account and redirects to root path" do
      expect do
        post accounts_path, params: {
          account: {
            name: "Cash",
            direction: "credit"
          }
        }
      end.to change(Account, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Conta criada com sucesso.")
    end
  end
end
