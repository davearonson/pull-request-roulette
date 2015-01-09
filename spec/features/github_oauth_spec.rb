require 'rails_helper.rb'

describe 'log in' do

  it 'logs people in with valid credentials' do
    pending 'need to figure out how to test with oauth redirects'
    raise "sheesh, shouldn't need to raise an error, take my word it's PENDING!"
    Given I am_not_logged_in
    When I try_to_submit_a_pr

    # GIVING UP HERE, because of extreme difficulty
    # of testing external redirects!  :-<

    # Then I am_redirected_to_github_login_page
    # When I submit_valid_credentials
    # Then I am_logged_in
    # Then I am_at_new_pr_page
  end

  # don't bother testing submission of invalid creds;
  # github won't let them proceed past that

end

private

def am_not_logged_in
  # ???
end

def submit_valid_credentials
  fill_in 'Username or Email', with: ENV['GITHUB_USERNAME']
  fill_in 'Password', with: ENV['GITHUB_PASSWORD']
  click_on 'Sign in'
end

def try_to_submit_a_pr
  visit new_pull_request_path
end

def am_at_new_pr_page
  expect(current_url.index(loc)).to eq new_pull_request_url
end

def am_logged_in
  expect($GITHUB_AUTH_TOKEN).not_to be_blank
end

def am_redirected_to_github_login_page
  loc = 'https://github.com/login?'
  expect(current_url.index(loc)).not_to eq == 0
end
