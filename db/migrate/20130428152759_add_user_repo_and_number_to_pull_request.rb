class AddUserRepoAndNumberToPullRequest < ActiveRecord::Migration

  # need to have a default else we can't migrate w/ extant data

  def up
    add_column :pull_requests, :user, :string, null: false, default: 'UNKNOWN'
    add_column :pull_requests, :repo, :string, null: false, default: 'UNKNOWN'
    add_column :pull_requests, :number, :integer, null: false, default: '0'
    PullRequest.all.each do |pr|
      pr.user, pr.repo, pr.number = PullRequest.parse_url pr.url
      pr.save!
    end
    remove_column :pull_requests, :url
  end

  def down
    add_column :pull_requests, :url, :string, null: false, default: 'UNKNOWN'
    PullRequest.all.each do |pr|
      pr.url = pr.to_url  # this method should then go away
      pr.save!
    end
    remove_column :pull_requests, :user
    remove_column :pull_requests, :repo
    remove_column :pull_requests, :number
  end

end
