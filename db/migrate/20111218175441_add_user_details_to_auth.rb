class AddUserDetailsToAuth < ActiveRecord::Migration
  def change
    add_column :authentications, :name, :string
    add_column :authentications, :email, :string
    add_column :authentications, :location, :string
    add_column :authentications, :image, :string
    #add_column :authentications, :followers_count, :integer
    #add_column :authentications, :listed_count, :integer
    add_column :authentications, :description, :string
    add_column :authentications, :nickname, :string
  end
end
