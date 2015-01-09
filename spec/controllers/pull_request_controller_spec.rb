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

  describe "close_review" do

    it "allows the reviewer, submitter, owner, or code author to close" do
      ["reviewer", "submitter", "owner", "author"].each do |name|
        try_to_close_pr_as(name)
        expect(flash[:alert]).to be_nil
      end
    end

    it "does not allows random others to close" do
      try_to_close_pr_as("random")
      expect(flash[:alert]).to include "you are not authorized"
    end

  end

  private

  def try_to_close_pr_as(name)
    controller.stub(:signed_in?).and_return(true)
    controller.stub(:current_user_handle).and_return(name)
    pr = PullRequest.new(user: "owner",
                         author: "author",
                         repo: "repo",
                         number: 1,
                         submitter: "submitter",
                         reviewer: "reviewer")
    pr.stub(:legit?).and_return(true)
    pr.save!
    PullRequest.stub(:find).and_return(pr)
    post :close_review, pull_request_id: pr.id
  end

end
