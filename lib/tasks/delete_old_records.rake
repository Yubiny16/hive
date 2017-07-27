namespace :delete do
  desc 'Delete records older than 60 days'
  task :old_records => :environment do
    Annoti.delete_all('created_at < ?', 60.days.ago)
    Pollnoti.delete_all('created_at < ?', 60.days.ago)
  end
end
