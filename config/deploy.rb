
require "bundler/capistrano"

set :application, "webcrawler_rails"
set :repository,  "git://github.com/daanforever/webcrawler_rails.git"

set :scm, :git
set :use_sudo, false

desc "Run tasks in production enviroment."
task :production do
  set :rails_env, "production"
  set :deploy_to, "/opt/capistrano/#{application}/production/"
end 

desc "Run tasks in staging enviroment."
task :staging do
  role :web, "www.dron.me"
  role :app, "www.dron.me"
  role :db,  "www.dron.me", :primary => true

  set :rails_env, "development"
  set :deploy_to, "/opt/capistrano/#{application}/staging/"
end

namespace :deploy do
  desc "Tell unicorn to restart the app."
  task :restart do
    run "cd #{current_path} && (script/spin restart || script/spin start)"
  end

  desc "Tell unicorn to stop the app."
  task :stop do
    run "cd #{current_path} && (script/spin stop)"
  end

  desc "Tell unicorn to start the app."
  task :start do
    run "cd #{current_path} && (script/spin start)"
  end
end


