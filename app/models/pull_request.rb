class PullRequest < ActiveRecord::Base

  # ORDER IS IMPORTANT!  url_parsed verifies presence of stuff needed for the rest.
  # found retrieves the PR, and open checks its state
  validate :validate_url_parsed
  validates_numericality_of :number, greater_than: 0, only_integer: true
  validates_uniqueness_of :number, scope: [:user, :repo], message: 'not unique; that pull request is already listed'
  validate :validate_found
  validate :validate_open

  def self.from_url url
    user, repo, number = self.parse_url url
    new user: user, repo: repo, number: number
  end

  def self.parse_url url
    match_data = url_regex.match(url)
    match_data[3..5] if match_data
  end

  def to_url
    self.class.url_format % [user, repo, number]
  end

  def self.url_format
    'https://github.com/%s/%s/pull/%d'
  end

  def self.url_regex
    /(https?:\/\/)?(www\.)?github.com\/(.*)\/(.*)\/pull\/([0-9]+)\z/
  end

  def validate_found
    return false if errors[:base].any?
    @pr_data = fetch_pr_data
    if ! @pr_data
      errors[:base] << 'That pull request was not found on Github'
      return false
    end
    true
  end

  def validate_open
    return false if ! @pr_data
    if @pr_data.state != 'open'
      errors[:base] << "That pull request is not open, it is #{@pr_data.state}"
      return false
    end
    true
  end

  # just to provide a bit clearer feedback
  def validate_url_parsed
    if ! (user && repo && number)
      errors[:base] << 'That is not a valid Github pull request URL'
      return false
    end
    true
  end

  private

  def fetch_pr_data
    github = Github.new client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET']
    begin
      github.pull_requests.find(user, repo, number)
    rescue ArgumentError, Github::Error::NotFound, URI::InvalidURIError
      nil
    end
  end

end
  
