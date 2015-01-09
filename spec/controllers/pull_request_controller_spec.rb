require "rails_helper"
require "ostruct"

describe PullRequestsController do

  describe "requires authorization" do

    before do
      set_up_faked_github_oauth
    end

    it "to get the form to submit a pr" do
      get :new
      expect(response).to redirect_to(@github_auth_url)
    end

    it "to submit a pr" do
      post :create
      expect(response).to redirect_to(@github_auth_url)
    end

    it "to take a pr" do
      post :take, pull_request_id: 1
      expect(response).to redirect_to(@github_auth_url)
    end

  end

  describe "take" do
    it "rejects taking an already taken pr" do
      controller.stub(:signed_in?).and_return(true)
      pr = PullRequest.from_url(url: pr_url, submitter: "whatever",
                                reviewer: "whatever")
      pr.save!
      post :take, pull_request_id: pr.id
      expect(flash[:alert]).to eq "Sorry, that PR is already under review."
    end
  end

end
