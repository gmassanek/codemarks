class AddUserDetailsToAuth < ActiveRecord::Migration
  def change
    add_column :authentications, :name, :string
    add_column :authentications, :profile_image_url, :string
    add_column :authentications, :location, :string
    add_column :authentications, :url, :string
    add_column :authentications, :followers_count, :integer
    add_column :authentications, :listed_count, :integer
    add_column :authentications, :description, :string
    add_column :authentications, :screen_name, :string
  end
end
