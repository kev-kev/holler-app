class AddResetDigestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_digest, :string
    add_column :users, :sent_at, :datetime
  end
end
