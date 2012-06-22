desc "This task is called by the Heroku scheduler add-on"

task :get_all_feeds => :environment do
  puts "Getting all feeds..."
  Feed.get_all
  puts "done."
end

