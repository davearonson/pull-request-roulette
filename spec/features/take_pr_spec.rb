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

  # never mind, this is covered by a controller test,
  # since NLI users don't even get a take button
  # it 'redirects a non-logged-in user to log in'

  # never mind, this is covered by a controller test,
  # since taken PRs don't even get a take button
  # it 'rejects taking an already-taken pr'

end

private

def take_it
  stub_finding_pr state: 'open'
  click_on "take-#{@pr.id}"
end
