require 'rails_helper.rb'

describe 'submit a pr' do

  it 'accepts URLs of open pr' do
    When I submit_open_pr
    Then I should_not_get_error_message
    Then pr_is_in_system
    Then I should_be_its_submitter
    Then its_author_should_be_listed
  end

  it 'rejects bad URLs' do
    When I submit_bad_url
    Then I should_get_error_message  # there will be a bunch in this case!
    Then pr_is_not_in_system
  end

  it 'rejects duplicate prs' do
    When I submit_preexisting_pr
    Then I should_get_error_message  'pull request is already listed'
    Then pr_is_not_in_system
  end

  it 'rejects pulls that do not exist' do
    When I submit_nonextant_pull
    Then I should_get_error_message 'pull request was not found on Github'
    Then pr_is_not_in_system
  end

  it 'rejects closed unmerged pulls' do
    When I submit_closed_pull
    Then I should_get_error_message 'pull request is not open'
    Then pr_is_not_in_system
  end

  it 'rejects merged pulls' do
    When I submit_merged_pull
    Then I should_get_error_message 'pull request is not open'
    Then pr_is_not_in_system
  end

  # NOTE: for tests of valid url formats,
  # see spec/models/pull_request_spec.rb

end

private

# GIVENS

# none at this time; should have some later for having logged in!

# WHENS

def submit_bad_url
  Given I am_signed_in
  # shouldn't get to the stage of finding
  submit_url 'http://thisisspam.com/fake-viagra.html'
end

def submit_closed_pull
  Given I am_signed_in
  stub_finding_pr state: 'closed'
  submit_url closed_pr_url
end

def submit_merged_pull
  Given I am_signed_in
  stub_finding_pr state: 'merged'
  submit_url merged_pr_url
end

def submit_nonextant_pull
  Given I am_signed_in
  PullRequest.any_instance.stub(:fetch_pr_data) { nil }
  submit_url 'https://github.com/nosuchuser/nosuchproject/pull/666'
end

def submit_open_pr
  Given I am_signed_in "#{test_user_handle}-As-Submitter"
  @author = "#{test_user_handle}-As-Author"
  stub_finding_pr state: 'open', author: @author
  submit_url pr_url
end

def submit_preexisting_pr
  Given I am_signed_in
  Given an_existing_pr
  submit_url @pr.to_url
end

# THENS

def should_be_its_submitter
  expect(page).to have_content @user_handle
end

def should_get_error_message(msg = nil)
  expect(page).to have_content msg_for_could_not_save
  expect(page).to have_content(msg) if msg.present?
  expect(page).not_to have_content msg_for_could_save
end

def should_not_get_error_message
  expect(page).not_to have_content msg_for_could_not_save
  expect(page).to have_content msg_for_could_save
end

def its_author_should_be_listed
  expect(page).to have_content @author
end

def pr_is_in_system
  user, repo, number = PullRequest.parse_url @pr_url
  expect(PullRequest.where(user: user).
                     where(repo: repo).
                     where(number: number).
                     count).to eq 1
end

def pr_is_not_in_system
  visit pull_requests_path
  expect(page).not_to have_content @pr_url
end

# HELPERS

def msg_for_could_not_save
  'prohibited this pull request from being saved'
end

def msg_for_could_save
  'was successfully created'
end

def submit_url(url)
  visit new_pull_request_path
  @pr_url = url
  fill_in 'url', with: url
  click_on 'Create Pull request'
end
