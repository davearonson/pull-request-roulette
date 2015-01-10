# GIVENS

def an_existing_pr(options = {})
  stub_finding_pr({ state: 'open' }.merge(options))
  @pr = PullRequest.from_url({ url: pr_url,
                               submitter: test_user_handle }.merge(options))
  @pr.save!
end

def am_signed_in(handle = test_user_handle)
  @user_handle = handle
  PullRequestsController.any_instance.stub(:authorize)
  PullRequestsController.any_instance.stub(:signed_in?) { true }
  PullRequestsController.any_instance.stub(:current_user_handle) { handle }
end

# WHENS

def list_the_prs
  visit pull_requests_path
end

def see_it_with_reviewer(name)
  within "#pr-#{@pr.id}" do
    within(".pr-url") { expect(page).to have_text pr_url.gsub("https://github.com/", "") }
    within(".pr-reviewer") { expect(page).to have_text name }
  end
end

# OTHER

def closed_pr_parts
  ['davearonson', 'pull-request-roulette', '16']
end

def closed_pr_url
  PullRequest.url_format % closed_pr_parts
end

def merged_pr_parts
  ['davearonson', 'pull-request-roulette', '15']
end

def merged_pr_url
  PullRequest.url_format % merged_pr_parts
end

def open_pr_parts
  ['davearonson', 'pull-request-roulette', '14']
end

def pr_url
  PullRequest.url_format % open_pr_parts
end

def stub_finding_pr(args = {})
  options = args.reverse_merge({ state: 'open', author: test_user_handle })
  PullRequest.any_instance.stub(:fetch_pr_data) { OpenStruct.new(state: options[:state],
                                                                 user: OpenStruct.new(login: options[:author])) }
end

def test_user_handle
  'J-Random-User'
end
