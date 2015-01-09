require 'rails_helper.rb'

describe 'take a pr' do

  it 'lets a logged-in user take a pr' do
    Given I am_signed_in
    Given an_existing_pr
    When I list_the_prs
    Then I see_it_with_reviewer "None"
    When I take_it
    And I list_the_prs
    Then I see_it_with_reviewer @user_handle
  end

  # it 'redirects a non-logged-in user to log in'
  # it 'rejects taking an already-taken pr'

end

private

def list_the_prs
  visit pull_requests_path
end

def see_it_with_reviewer(name)
  within "#pr-#{@pr.id}" do
    within(".pr-url") { expect(page).to have_text pr_url.gsub("https://github.com/", "") }
    within(".pr-reviewer") { expect(page).to have_text name }
  end
end

def take_it
  stub_finding_pr state: 'open'
  click_on "take-#{@pr.id}"
end
