class Seeder
  class << self
    def create_topics(titles)
      titles.map { |title| Fabricate(:topic, :title => title) }
    end

    def create_user(nickname)
      auth = Authentication.new(:uid => rand(99999).to_s, :nickname => nickname, :provider => 'twitter')
      User.create!(:authentications => [auth])
    end

    def create_me
      auth = Authentication.new(:uid => '987877', :nickname => 'gmassanek', :provider => 'twitter', :image => 'http://www.gravatar.com/avatar/58dbba1be3de0ccf3a495e978bdcb220.png')
      User.create!(:authentications => [auth])
    end

    def create_codemark(url, user)
      link = Link.load(:url => url)
      link.link_record.update_attributes(:author_id => user.id)
      attributes = {
        :resource => link.link_record,
        :user_id => user.id,
        :topic_ids => link.tag_ids
      }
      CodemarkRecord.create!(attributes)
    end

    def clear_database
      CodemarkRecord.destroy_all
      LinkRecord.destroy_all
      User.destroy_all
      Click.destroy_all
      Authentication.destroy_all
      Topic.destroy_all
    end
  end
end

