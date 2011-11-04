class CreateSponsoredSites < ActiveRecord::Migration

  def change
    create_table :sponsored_sites do |t|
      t.integer :topic_id
      t.string :site
      t.string :url

      t.timestamps
    end
  end

end
