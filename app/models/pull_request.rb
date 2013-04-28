class PullRequest < ActiveRecord::Base

  # TODO: figure out how to make the same validator happen on both events.
  # the obvious way, using an array, does not work!
  validate :open?, on: :create
  validate :still_open?, on: :update

  def self.from_url url
      user, repo, number = self.parse_url url
      self.class.new user: user, repo: repo, number: number
  end

  def open?
    user, repo, num = self.class.parse_url url
    if ! (user && repo && num)
      errors[:base] << 'That is not a valid Github pull request URL'
      return false
    end
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
  alias_method :still_open?, :open?

  def self.parse_url url
    regex = /https?:\/\/(www\.)?github.com\/(.*)\/(.*)\/pull\/([0-9]+)\z/
    parsing = regex.match url
    parsing ||= []
    parsing[2..4]
  end

end
