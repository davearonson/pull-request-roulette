require "rails_helper"
require "ostruct"

describe PullRequestsController do

  before do
    ENV['GITHUB_KEY'] = @key = "this is the github key"
    ENV['GITHUB_SECRET'] = @secret = "this is the github secret"
    @github_auth_url = "github auth url"
    fake_github_client = OpenStruct.new(:authorize_url => @github_auth_url)
    expect(Github).to receive(:new).
      with({ client_id: @key, client_secret: @secret }).
      and_return(fake_github_client)
  end

  it "requires authorization to get the form to submit a pr" do
    get :new
    expect(response).to redirect_to(@github_auth_url)
  end

  it "requires authorization to submit a pr" do
    post :create
    expect(response).to redirect_to(@github_auth_url)
  end

  it "requires authorization to take a pr" do
    post :take, pull_request_id: 1
    expect(response).to redirect_to(@github_auth_url)
  end

end
