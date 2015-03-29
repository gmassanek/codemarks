class EnableHstoreIfNotAlready < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
  end
end
