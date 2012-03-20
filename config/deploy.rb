
require "bundler/capistrano"

set :application, "webcrawler_rails"
set :repository,  "git://github.com/daanforever/webcrawler_rails.git"

set :scm,         :git
set :use_sudo,    false
set :user,        "crawler"

set :branch,      "0.2"

depend :remote,   :command, "ruby"
depend :remote,   :command, "gem"
depend :remote,   :command, "bundle"

desc "Run tasks in production enviroment."
task :production do
  set :rails_env, "production"
  set :deploy_to, "/opt/apps/#{application}/#{rails_env}/"

  role :web, "crawler.dron.me"
  role :app, "crawler.dron.me"
  role :db,  "crawler.dron.me", :primary => true
end 

desc "Run tasks in staging enviroment."
task :staging do
  role :web, "www.dron.me"
  role :app, "www.dron.me"
  role :db,  "www.dron.me", :primary => true

  set :rails_env, "staging"
  set :deploy_to, "/opt/apps/#{application}/#{rails_env}/"
end

desc "Run tasks in staging enviroment."
task :development do
  role :web, "www.dron.me"
  role :app, "www.dron.me"
  role :db,  "www.dron.me", :primary => true

  set :rails_env, "development"
  set :deploy_to, "/opt/apps/#{application}/#{rails_env}/"
end

namespace :deploy do
  desc "Tell unicorn to restart the app."
  task :restart do
    run "cd #{current_path} && (test -e tmp/pids/unicorn.pid && kill -USR2 `cat tmp/pids/unicorn.pid`) || true"
  end

  desc "Tell unicorn to stop the app."
  task :stop do
    run "cd #{current_path} && test -e tmp/pids/unicorn.pid && kill `cat tmp/pids/unicorn.pid`"
  end

  desc "Tell unicorn to start the app."
  task :start do
    run "cd #{current_path} && bundle exec unicorn_rails -c config/unicorn/#{rails_env}.rb -E #{rails_env} -D"
  end

  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Create config directory for database.yml"
  task :create_db_config_dir, :roles => :app do
    run "test -e #{deploy_to}/shared/config || mkdir #{deploy_to}/shared/config"
  end

  desc "Fix permissions"
  task :fix_permissions, :roles => :app do
    run "chown -R #{user}:www-data #{deploy_to}"
    run "chmod -R o-rwx #{deploy_to}"
  end
end

namespace :db do
  
    desc "Syncs the database.yml file from the local machine to the remote machine"
    task :sync_yaml do
      puts "\n\n=== Syncing database yaml to the production server! ===\n\n"
      unless File.exist?("config/database.yml")
        puts "There is no config/database.yml.\n "
        exit
      end
      #run what u want
    end
    
    desc "Create Database"
    task :create do
      puts "\n\n=== Creating Database! ===\n\n"
      run "cd #{current_path}; rake db:create RAILS_ENV=#{rails_env}"
    end
  
    desc "Migrate Database"
    task :migrate do
      puts "\n\n=== Migrating the Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=#{rails_env}"
    end

    desc "Resets the Database"
    task :migrate_reset do
      puts "\n\n=== Resetting the Database! ===\n\n"
      run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:migrate:reset"
    end
    
    desc "Destroys Database"
    task :drop do
      puts "\n\n=== Destroying the Database! ===\n\n"
      run "cd #{current_path}; rake db:drop RAILS_ENV=#{rails_env}"
    end

    desc "Populates the Database"
    task :seed do
      puts "\n\n=== Populating the Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
    end
  
end

after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:setup', 'deploy:create_db_config_dir'
after 'deploy:setup', 'deploy:fix_permissions'

