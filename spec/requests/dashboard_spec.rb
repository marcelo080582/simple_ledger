require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path

      expect(response).to have_http_status(:success)
    end

    it "displays accounts with directions" do
      account = Account.create!(name: "Cash", direction: "debit")

      get root_path

      expect(response.body).to include("Cash")
      expect(response.body).to include("Debit")
    end

    it "displays account creation form" do
      get root_path

      expect(response.body).to include("Create Account")
      expect(response.body).to include("Name")
      expect(response.body).to include("Direction")
      expect(response.body).to include("Debit")
      expect(response.body).to include("Credit")
    end
  end
end
