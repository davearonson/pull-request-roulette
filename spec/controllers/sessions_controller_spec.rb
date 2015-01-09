require "rails_helper"
require "ostruct"

describe SessionsController do

  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end

  # mainly doing this to test authorize_github_and_return_to
  describe "#new" do

    before do
      set_up_faked_github_oauth
    end

    it "stashes referer url to redirect to" do
      url = "this represents a url"
      expect(session[:redirect_url]).to be_nil # sanity check
      expect(controller.request).to receive(:referer).and_return(url)
      get :new
      expect(session[:redirect_url]).to eq url
    end

    it "stashes root url to redirect to if no referer" do
      url = "this represents a url"
      session[:redirect_url] = "not " + url
      expect(session[:redirect_url]).not_to eq url  # sanity check
      get :new
      expect(session[:redirect_url]).to eq root_path
    end

    it "creates a new Github client with the correct params" do
      get :new
    end

    it "redirects to the github authorization url" do
      get :new
      expect(response).to redirect_to(@github_auth_url)
    end

  end

  describe "#create" do
    it "should successfully create a session" do
      expect(session[:handle]).to be_nil
      post :create, provider: :github
      expect(session[:handle]).not_to be_nil
    end
  end

  describe "#destroy" do

    it "should clear the session" do
      session[:auth_code] = "this is an auth code"
      delete :destroy
      expect(session[:auth_code]).to be_nil
    end

    it "should redirect to the home page" do
      delete :destroy
      expect(response).to redirect_to root_url
    end

  end

end
