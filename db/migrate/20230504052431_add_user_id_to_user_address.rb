class AddUserIdToUserAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :user_addresses, :user_id, :integer
  end
end
