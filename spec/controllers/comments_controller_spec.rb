require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do
    it "should allow a user to comment on an existing gram" do
      g = FactoryGirl.create(:gram)
      u = FactoryGirl.create(:user)
      sign_in u
      post :create, gram_id: g.id, comment: { message: 'nice'}
      expect(response).to redirect_to root_path
      expect(g.comments.length).to eq 1
      expect(g.comments.first.message).to eq "nice"
    end

    it "should not allow a non-logged in user to comment on an existing gram" do
      g = FactoryGirl.create(:gram)
      post :create, gram_id: g.id, comment: { message: 'trolling' }
      expect(response).to redirect_to new_user_session_path
      expect(g.comments.length).to eq 0
    end

    it "should return not found if attempting a comment on a gram that does not exist" do
      u = FactoryGirl.create(:user)
      sign_in u
      post :create, gram_id: 'nullz', comment: {message: 'lulz'}
      expect(response).to have_http_status(:not_found)
    end
  end



end
