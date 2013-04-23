require 'spec_helper'

describe "pull_requests/index" do
  before(:each) do
    assign(:pull_requests, [
      stub_model(PullRequest),
      stub_model(PullRequest)
    ])
  end

  it "renders a list of pull_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
