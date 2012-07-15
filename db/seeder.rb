class Seeder
  class << self
    def create_topics(titles)
      titles.map { |title| Fabricate(:topic, :title => title) }
    end

    def create_user(nickname)
      auth = Authentication.new(:uid => '422333', :nickname => nickname, :provider => 'twitter')
      User.create!(:authentications => [auth])
    end

    def create_codemark(url, user)
      link = Link.load(:url => url)
      attributes = {
        :resource_id => link.id,
        :user_id => user.id
      }
      topic_info = {
        :ids => link.tag_ids
      }
      Codemark.create(attributes, topic_info)
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

