require "rails_helper"
require "ostruct"

describe SessionsController do

  describe "authorize_github_and_return_to" do

    before do
      ENV['GITHUB_KEY'] = @key = "this is the github key"
      ENV['GITHUB_SECRET'] = @secret = "this is the github secret"
      @github_auth_url = "github auth url"
      fake_github_client = OpenStruct.new(:authorize_url => @github_auth_url)
      Github.stub(:new).and_return(fake_github_client)
    end

    it "stashes referer url to redirect to" do
      url = "this represents a url"
      session[:redirect_url] = "not " + url
      expect(session[:redirect_url]).not_to eq url  # sanity check
      controller.request.should_receive(:referer).and_return(url)
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
      expect(Github).to receive(:new).with({ client_id: @key,
                                             client_secret: @secret })
      get :new
    end

    it "redirects to the github authorization url" do
      get :new
      expect(response).to redirect_to(@github_auth_url)
    end

  end

end
