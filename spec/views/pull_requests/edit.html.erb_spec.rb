require 'spec_helper'

describe "pull_requests/edit" do
  before(:each) do
    @pull_request = assign(:pull_request, stub_model(PullRequest))
  end

  it "renders the edit pull_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", pull_request_path(@pull_request), "post" do
    end
  end
end
