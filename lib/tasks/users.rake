namespace :users  do
  desc "save link.author_id based on first codemark.user"

  task :merge_accounts_for_user, [:nickname] => :environment do |t, args|
    nickname = args[:nickname]
    auths = Authentication.find(:all, :conditions => {:nickname => nickname})
    users = auths.collect(&:user).uniq
    p users
    if users.count == 2
      Rake::Task['users:merge_two_user_accounts'].execute({:user_id1 => users.first.id, :user_id2 => users.last.id})
    end
  end

  task :merge_two_user_accounts, [:user_id1, :user_id2] => :environment do |t, args|
    deleting = {
      auth: false,
      codemarks: false
    }
    moving = {
      auth: false,
      codemarks: false,
      clicks: false,
      nuggets: false,
      topics: false
    }

    user1 = User.find(args[:user_id1])
    user2 = User.find(args[:user_id2])

    secondary, primary = [user1, user2].sort_by { |user| user.codemarks.count }
    p "Moving items from from user #{secondary.id} to user #{primary.id}"
    
    p ""
    p ""
    p ""
    p 'Authentication Count'
    p "Primary: #{primary.authentications.count}"
    p "Secondary: #{secondary.authentications.count}"

    secondary.authentications.each do |authentication|
      provider = authentication.provider
      main_auth = primary.authentication_by_provider(provider)
      if main_auth 
        if authentication.uid != main_auth.uid
          p "ERROR:"
          p "Users #{primary.id} and #{secondary.id} have conflicting authentications"
          p "#{provider} nickname: #{authentication.nickname}"
          p "User #{primary.id} uid: #{main_auth.uid}"
          p "User #{secondary.id} uid: #{authentication.uid}"
          next
        else
          p "Deleting authentication #{authentication.id}"
          authentication.destroy if deleting[:auth]
        end
      else
        p "Moving authentication #{authentication.provider}:#{authentication.uid}"
        authentication.update_attributes(:user_id => primary.id) if moving[:auth]
      end
    end
    p "Primary: #{primary.authentications.count}"
    p "Secondary: #{secondary.authentications.count}"

    p ""
    p ""
    p ""
    p 'Codemark Count'
    p "Primary: #{primary.codemarks.count}"
    p "Secondary: #{secondary.codemarks.count}"

    primary_link_ids = primary.codemarks.map(&:link_id)
    p primary_link_ids
    p secondary.codemarks.map(&:link_id)
    secondary.codemarks.each do |codemark|
      if primary_link_ids.include?(codemark.link_id)
        p "Deleting codemark #{codemark.id}"
        codemark.destroy if deleting[:codemarks]
      else
        p "Moving codemark #{codemark.id}"
        codemark.update_attributes(:user_id => primary.id) if moving[:codemarks]
      end
    end
    p "Primary: #{primary.codemarks.count}"
    p "Secondary: #{secondary.codemarks.count}"

    p ""
    p ""
    p ""
    p 'Click Count'
    p "Primary: #{primary.clicks.count}"
    p "Secondary: #{secondary.clicks.count}"
    secondary.clicks.each do |click|
      p "Moving click for link #{click.link_id}"
      click.update_attributes(:user_id => primary.id) if moving[:clicks]
    end
    p "Primary: #{primary.clicks.count}"
    p "Secondary: #{secondary.clicks.count}"

    p ""
    p ""
    p ""
    p 'Nuggets Count'
    p "Primary: #{primary.nuggets.count}"
    p "Secondary: #{secondary.nuggets.count}"
    secondary.nuggets.each do |nugget|
      p "Moving nugget for link #{nugget.id}"
      nugget.update_attributes(:author_id => primary.id) if moving[:nuggets]
    end
    p "Primary: #{primary.nuggets.count}"
    p "Secondary: #{secondary.nuggets.count}"

    #p ""
    #p ""
    #p ""
    #p 'Topics Count'
    #p "Primary: #{primary.topics.count}"
    #p "Secondary: #{secondary.topics.count}"
    #secondary.topics.each do |topic|
      #p "Moving topic #{topic.id}"
      #if moving[:topics]
        #topic.user_id = primary.id
        #topic.save!
      #end
    #end
    #p "Primary: #{primary.topics.count}"
    #p "Secondary: #{secondary.topics.count}"

  end
end
