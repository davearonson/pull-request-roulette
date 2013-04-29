class PullRequest < ActiveRecord::Base

  def self.from_url url
    user, repo, number = self.parse_url url
    new user: user, repo: repo, number: number
  end

  def self.parse_url url
    match_data = url_regex.match(url)
    match_data[2..4] if match_data
  end

  def to_url
    self.class.url_format % [user, repo, number]
  end

  def self.url_format
    'http://github.com/%s/%s/pull/%d'
  end

  def self.url_regex
    /https?:\/\/(www\.)?github.com\/(.*)\/(.*)\/pull\/([0-9]+)\z/
  end

end
  
