require_relative '../spec_helper.rb'

describe 'submit a pr' do
  # this is satisfied by basic crud
  it 'lets a user add a pr' do
    given_pr_not_in_system
    when_pr_is_submitted
    then_pr_is_in_system
  end
end

private

def given_pr_not_in_system
  @pr_url = "https://github.com/thomasjefferson/usa/pull/1776"
  visit pull_requests_path
  page.should_not have_content @pr_url
end

def when_pr_is_submitted
  visit new_pull_request_path
  fill_in 'URL', with: @pr_url
  click_on 'Create Pull request'
end

def then_pr_is_in_system
  visit pull_requests_path
  page.should have_content @pr_url
end
