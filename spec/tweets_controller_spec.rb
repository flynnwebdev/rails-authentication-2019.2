require "rails_helper"

RSpec.describe TweetsController, type: :controller do
  context "Not Logged In" do
    it "GET #index redirects to login form" do
      get :index
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "Logged In" do
    before(:each) do
      @user = User.create(email: "test@test.com", password: "password", password_confirmation: "password")
      sign_in @user
      @tweet = Tweet.create(title: "Test Tweet", content: "This is a test", user: @user)
    end

    it "GET #index show list of Tweets" do
      get :index
      expect(response).to render_template(:index)
    end

    it "GET #show shows details of a single Tweet" do
      get :show, params: { id: @tweet }
      expect(response).to render_template(:show)
    end

    describe "Create a Tweet" do
      context "Valid Params" do
        before(:each) do
          post :create, params: { tweet: { title: "Test Tweet", content: "This is a test" } }
        end

        it "POST #create creates a new Tweet" do
          expect(Tweet.last.title).to eq("Test Tweet")
          expect(Tweet.last.content).to eq("This is a test")
        end

        it "POST #create redirects to the new Tweet" do
          expect(response).to redirect_to(Tweet.last)
        end
      end

      context "Invalid Params" do
        before(:each) do
          post :create, params: { tweet: { title: "", content: "" } }
        end

        it "POST #create renders the 'new Tweet' template" do
          expect(response).to render_template(:new)
        end
      end
    end
  end

  after(:all) do
      Tweet.destroy_all
      User.destroy_all
  end
end
