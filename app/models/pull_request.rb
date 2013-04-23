class PullRequest < ActiveRecord::Base
  validates_format_of :url,
                      with: /https?:\/\/(www\.)?github.com\/.*\/.*\/pull\/[0-9]+/
end
