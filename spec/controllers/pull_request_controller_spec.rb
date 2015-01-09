require "rails_helper"
require "ostruct"

describe PullRequestsController do

  before do
    set_up_faked_github_oauth
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
