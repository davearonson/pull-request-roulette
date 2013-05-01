require_relative '../spec_helper.rb'

describe 'take a pr' do

  # this is satisfied by basic crud
  it 'lets a user take a pr' do
    given_i_am_signed_in
    given_an_existing_pr
    when_i_ask_for_one
    then_i_am_told_about_it
    when_i_take_it
    when_i_ask_for_one
    then_i_am_not_told_about_it
  end

end

private

def when_i_ask_for_one
  visit pull_requests_path
end

def then_i_am_told_about_it
  page.html.should include open_pr_url
end

def when_i_take_it
  stub_finding_pr
  click_on "take-#{@pr.id}"
end

def then_i_am_not_told_about_it
  page.html.should_not include open_pr_url
end
