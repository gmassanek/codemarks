class AddIndexToAuthenticationsForLogin < ActiveRecord::Migration
  def change
    add_index :authentications, [:uid, :provider]
  end
end
