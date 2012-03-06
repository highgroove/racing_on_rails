namespace :racing_on_rails do
  
  desc 'Cold setup' 
  task :bootstrap do
    puts "Bootstrap task will delete your Racing on Rails development database."
    db_password = ask("MySQL root password (press return for no password): ")
    puts "Create databases"
    puts `mysql -u root #{db_password_arg(db_password)} < #{File.expand_path(::Rails.root.to_s + "/db/create_databases.sql")}`
    puts "Populate development database"
    puts `mysql -u root #{db_password_arg(db_password)} racing_on_rails_development -e "SET FOREIGN_KEY_CHECKS=0; source #{File.expand_path(::Rails.root.to_s + "/db/structure.sql")}; SET FOREIGN_KEY_CHECKS=1;"`
    puts "Start server"
    puts "Please open http://localhost:8080/ in your web browser"
    puts `unicorn`
  end
end

namespace :db do
  namespace :structure do
    desc "Monkey-patched by Racing on Rails. Standardize format to prevent source control churn."
    task :dump => :environment do
      sql = File.open("#{::Rails.root.to_s}/db/structure.sql").readlines.join
      sql.gsub!(/AUTO_INCREMENT=\d+ +/i, "")

      File.open("#{::Rails.root.to_s}/db/structure.sql", "w") do |file|
        file << sql
      end
    end
  end
end

def ask(message)
  print message
  STDIN.gets.chomp
end

def db_password_arg(db_password)
  if db_password.blank?
    ""
  else
    " --password=#{db_password}"
  end
end

namespace :doc do
  desc "Upload RDoc to WWW server"
  task :upload => [:clobber_app, :app] do
    `scp -r doc/app/ butlerpress.com:/usr/local/www/www.butlerpress.com/racing_on_rails/rdoc`
  end
end
