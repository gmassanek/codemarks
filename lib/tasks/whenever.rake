namespace :whenever do
  desc 'Tweet out the codemark of the day'
  task :codemark_of_the_day => :environment do
    p CodemarkRecord.where(["DATE(created_at) = ?", Date.today-1]).first
  end
end
