require_relative '../spec_helper.rb'

describe 'submit a pr' do

  it 'accepts valid URLs' do
    when_i_submit_good_url
    then_i_should_not_get_error_message
    then_pr_is_in_system
  end

  it 'rejects bad URLs' do
    when_i_submit_totally_bad_url
    then_i_should_get_error_message 'not a valid Github pull request'
    then_pr_is_not_in_system
  end

  it 'rejects pulls that do not exist' do
    when_i_submit_nonextant_pull
    then_i_should_get_error_message 'ull request not found'
    then_pr_is_not_in_system
  end

  it 'rejects closed pulls' do
    when_i_submit_closed_pull
    then_i_should_get_error_message 'pull request is not open'
    then_pr_is_not_in_system
  end

end

private

# GIVENS

def given_on_new_pr_page
  visit new_pull_request_path
end

# WHENS

def when_i_submit_closed_pull
  Github::PullRequests.any_instance.should_receive(:find).and_return(OpenStruct.new(state: 'closed'))
  submit_url 'https://github.com/bogususer/bogusproject/pull/777'
end

def when_i_submit_good_url
  Github::PullRequests.any_instance.should_receive(:find).and_return(OpenStruct.new(state: 'open'))
  submit_url 'http://github.com/rails/rails/pull/2045'
end

def when_i_submit_nonextant_pull
  Github::PullRequests.any_instance.should_receive(:find).and_return(nil)
  submit_url 'https://github.com/nosuchuser/nosuchproject/pull/666'
end

def when_i_submit_totally_bad_url
  submit_url 'http://thisisspam.com/fake-viagra.html'
end

# THENS

def then_i_should_get_error_message msg=nil
  page.should have_content msg_for_could_not_save
  page.should have_content(msg) if msg.present?
  page.should_not have_content msg_for_could_save
end

def then_i_should_not_get_error_message
  page.should_not have_content msg_for_could_not_save
  page.should have_content msg_for_could_save
end

def then_pr_is_in_system
  visit pull_requests_path
  page.should have_content @pr_url
end

def then_pr_is_not_in_system
  visit pull_requests_path
  page.should_not have_content @pr_url
end

# HELPERS

def msg_for_could_not_save
  'prohibited this pull_request from being saved'
end

def msg_for_could_save
  'was successfully created'
end

def submit_url url
  visit new_pull_request_path
  @pr_url = url
  fill_in 'URL', with: @pr_url
  click_on 'Create Pull request'
end
