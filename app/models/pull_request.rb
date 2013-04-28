class PullRequest < ActiveRecord::Base

  # TODO: figure out how to make the same validator happen on both events.
  # the obvious way, using an array, does not work!
  validate :is_an_open_github_pr?, on: :create
  validate :is_still_an_open_github_pr?, on: :update

  def is_an_open_github_pr?
    pr_url_regex = /https?:\/\/(www\.)?github.com\/(.*)\/(.*)\/pull\/([0-9]+)\z/
    parsing = pr_url_regex.match url
    if ! parsing
      errors[:base] << 'That is not a valid Github pull request URL'
      return false
    end
    user = parsing[2]
    repo = parsing[3]
    num = parsing[4]
    begin
      pr = Github.new.pull_requests.find(user, repo, num)
    rescue Github::Error::NotFound, URI::InvalidURIError
      pr = nil
    end
    if ! pr
      errors[:base] << 'Pull request not found on Github'
      return false
    elsif pr.state != 'open'
      errors[:base] << 'That pull request is not open'
      return false
    end
    true
  end
  alias_method :is_still_an_open_github_pr?, :is_an_open_github_pr?

  def self.parse_url url
    regex = /https?:\/\/(www\.)?github.com\/(.*)\/(.*)\/pull\/([0-9]+)\z/
    parsing = regex.match url
    parsing[2..4]
  end

end
