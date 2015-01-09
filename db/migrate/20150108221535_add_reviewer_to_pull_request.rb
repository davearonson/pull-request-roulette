class AddReviewerToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :reviewer, :string, null: true, limit: 39
  end
end
