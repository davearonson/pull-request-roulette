require_relative '../spec_helper.rb'

describe 'take a pr' do
  # this is satisfied by basic crud
  it 'lets a user take a pr' do
    given_pr_available
    when_i_ask_for_one
    then_i_am_told_about_it
    when_i_take_it
    when_i_ask_for_one
    then_i_am_not_told_about_it
  end
end

private

def given_pr_available
  @pr = PullRequest.create(url: "https://github.com/tj/usa/pull/1776")
end

def when_i_ask_for_one
  visit pull_requests_path
end

def then_i_am_told_about_it
  page.should have_content @pr.url
end

def when_i_take_it
  click_on "take-#{@pr.id}"
end

def then_i_am_not_told_about_it
  page.should_not have_content @pr.url
end
