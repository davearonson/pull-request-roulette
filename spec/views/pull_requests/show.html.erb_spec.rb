require 'spec_helper'

describe "pull_requests/show" do
  before(:each) do
    @pull_request = assign(:pull_request, stub_model(PullRequest))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
