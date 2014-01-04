namespace :db  do
  desc "Restore from db/backups/production_bkup.sql"
  task :pg_restore  => [:drop, :create] do
    `psql codemarks_development -f db/backups/production_bkup.sql`
    Rake::Task["test:prepare"].invoke
    puts "DONE"
  end
end

