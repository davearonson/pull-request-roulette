require_relative '../spec_helper.rb'

describe 'submit a pr' do

  it 'accepts URLs of open pr' do
    when_i_submit_open_pr
    then_i_should_not_get_error_message
    then_pr_is_in_system
  end

  it 'rejects bad URLs' do
    when_i_submit_bad_url
    then_i_should_get_error_message  # there will be a bunch in this case!
    then_pr_is_not_in_system
  end

  it 'rejects pulls that do not exist' do
    when_i_submit_nonextant_pull
    then_i_should_get_error_message 'ull request not found'
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

end

private

# GIVENS

def given_on_new_pr_page
  visit new_pull_request_path
end

# WHENS

def when_i_submit_closed_pull
  PullRequest.any_instance.stub(:validate_found?) { set_instance_variable(:@pr, OpenStruct(state: 'closed')) }
  submit_url closed_pr_url
end

def when_i_submit_merged_pull
  PullRequest.any_instance.stub(:validate_found?) { set_instance_variable(:@pr, OpenStruct(state: 'merged')) }
  submit_url merged_pr_url
end

def when_i_submit_nonextant_pull
  PullRequest.any_instance.stub(:validate_found?) { set_instance_variable(:@pr, nil) }
  submit_url 'https://github.com/nosuchuser/nosuchproject/pull/666'
end

def when_i_submit_open_pr
  PullRequest.any_instance.stub(:validate_found?) { set_instance_variable(:@pr, OpenStruct(state: 'open')) }
  submit_url open_pr_url
end

def when_i_submit_bad_url
  # shouldn't get to the stage of finding
  PullRequest.any_instance.stub(:validate_found?) { raise 'Ooops, we should not get here!' }
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
  user, repo, number = PullRequest.parse_url @pr_url
  PullRequest.where(user: user).where(repo: repo).where(number: number).count.should == 1
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
  fill_in 'url', with: @pr_url
  click_on 'Create Pull request'
end
