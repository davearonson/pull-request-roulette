class AddAuthorToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :author, :string, null: false, default: 'UNKNOWN'
  end
end
