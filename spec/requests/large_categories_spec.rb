require 'rails_helper'

RSpec.describe "LargeCategories", type: :request do
  describe "GET /index" do
    it "returns http success" do
      sign_in create(:user)
      get large_categories_path
      expect(response).to have_http_status(:success)
    end
  end
end
