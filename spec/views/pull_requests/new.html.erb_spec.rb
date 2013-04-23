require 'spec_helper'

describe "pull_requests/new" do
  before(:each) do
    assign(:pull_request, stub_model(PullRequest).as_new_record)
  end

  it "renders new pull_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", pull_requests_path, "post" do
    end
  end
end
