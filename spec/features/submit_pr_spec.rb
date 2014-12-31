require 'rails_helper.rb'

describe 'submit a pr' do

  it 'accepts URLs of open pr' do
    when_i_submit_open_pr
    then_i_should_not_get_error_message
    then_pr_is_in_system
    then_i_should_be_its_submitter
    then_its_author_should_be_listed
  end

  it 'rejects bad URLs' do
    when_i_submit_bad_url
    then_i_should_get_error_message  # there will be a bunch in this case!
    then_pr_is_not_in_system
  end

  it 'rejects duplicate prs' do
    when_i_submit_preexisting_pr
    then_i_should_get_error_message  'pull request is already listed'
    then_pr_is_not_in_system
  end

  it 'rejects pulls that do not exist' do
    when_i_submit_nonextant_pull
    then_i_should_get_error_message 'pull request was not found on Github'
    then_pr_is_not_in_system
  end

  it 'rejects closed unmerged pulls' do
    when_i_submit_closed_pull
    then_i_should_get_error_message 'pull request is not open'
    then_pr_is_not_in_system
  end

  it 'rejects merged pulls' do
    when_i_submit_merged_pull
    then_i_should_get_error_message 'pull request is not open'
    then_pr_is_not_in_system
  end

  # NOTE: for tests of valid url formats,
  # see spec/models/pull_request_spec.rb

end

private

# GIVENS

# none at this time; should have some later for having logged in!

# WHENS

def when_i_submit_bad_url
  given_i_am_signed_in
  # shouldn't get to the stage of finding
  submit_url 'http://thisisspam.com/fake-viagra.html'
end

def when_i_submit_closed_pull
  given_i_am_signed_in
  stub_finding_pr state: 'closed'
  submit_url closed_pr_url
end

def when_i_submit_merged_pull
  given_i_am_signed_in
  stub_finding_pr state: 'merged'
  submit_url merged_pr_url
end

def when_i_submit_nonextant_pull
  given_i_am_signed_in
  PullRequest.any_instance.stub(:fetch_pr_data) { nil }
  submit_url 'https://github.com/nosuchuser/nosuchproject/pull/666'
end

def when_i_submit_open_pr
  given_i_am_signed_in "#{test_user_handle}-As-Submitter"
  @author = "#{test_user_handle}-As-Author"
  stub_finding_pr state: 'open', author: @author
  submit_url open_pr_url
end

def when_i_submit_preexisting_pr
  given_i_am_signed_in
  given_an_existing_pr
  submit_url @pr.to_url
end

# THENS

def then_i_should_be_its_submitter
  expect(page).to have_content @user_handle
end

def then_i_should_get_error_message(msg = nil)
  expect(page).to have_content msg_for_could_not_save
  expect(page).to have_content(msg) if msg.present?
  expect(page).not_to have_content msg_for_could_save
end

def then_i_should_not_get_error_message
  expect(page).not_to have_content msg_for_could_not_save
  expect(page).to have_content msg_for_could_save
end

def then_its_author_should_be_listed
  expect(page).to have_content @author
end

def then_pr_is_in_system
  user, repo, number = PullRequest.parse_url @pr_url
  expect(PullRequest.where(user: user).
                     where(repo: repo).
                     where(number: number).
                     count).to eq 1
end

def then_pr_is_not_in_system
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
