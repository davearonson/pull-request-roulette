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
  PullRequest.any_instance.stub(:validate_found?) { set_instance_variable(:@pr, OpenStruct(state: 'open')) }
  @pr = PullRequest.from_url(open_pr_url)
  @pr.save!
end

def when_i_ask_for_one
  visit pull_requests_path
end

def then_i_am_told_about_it
  page.should have_content open_pr_parts.join(' ')
end

def when_i_take_it
  click_on "take-#{@pr.id}"
end

def then_i_am_not_told_about_it
  page.should_not have_content open_pr_parts.join(' ')
end
