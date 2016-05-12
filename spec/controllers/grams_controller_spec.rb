require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy action" do
    it "should allow a user to destroy grams" do
      g = FactoryGirl.create(:gram)
      delete :destroy, id: g.id
      expect(response).to redirect_to root_path
      g = Gram.find_by_id(g.id)
      expect(g).to eq nil
    end

    it "should return a 404 if the specified gram is not found" do
      delete :destroy, id: 'QUACKERY'
      expect(response).to have_http_status(:not_found)
    end  
  end

  describe "grams#update action" do
    it "should allow users to successfully update grams" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      patch :update, id: gram.id, gram: { message: "Changed" }
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      patch :update, id: "HUMBUG", gram: { message: "BAH"}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity for a bad edit" do
      g = FactoryGirl.create(:gram, message: "Initial Value")
      patch :update, id: g.id, gram: { message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      g.reload
      expect(g.message).to eq "Initial Value"
    end
  end

  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :edit, id: 'tacocat'
      expect(response).to have_http_status(:not_found)
    end

    it "should return an error if the gram does not belong to the user" do
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require a logged in user" do
      post :create, gram: { message: "fail!"}
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, gram: {message: 'Hello!'}
      expect(response).to redirect_to root_path
      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user
      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end



end
