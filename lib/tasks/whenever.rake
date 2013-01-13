namespace :whenever do
  desc 'Tweet out the codemark of the day'
  task :codemark_of_the_day => :environment do
    next unless ENV['RAILS_ENV'] == 'production'

    puts "Codemark of the Day"
    puts Time.now

    codemark_of_the_day = CodemarkRecord.most_popular_yesterday
    if codemark_of_the_day
      puts codemark_of_the_day

      puts tweet = TweetFactory.codemark_of_the_day(codemark_of_the_day)
      Twitter.update(tweet)
    else
      puts "No codemarks saved yesterday"
    end
  end
end
