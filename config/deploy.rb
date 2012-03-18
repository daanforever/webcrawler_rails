set :application, "webcrawler_rails"
set :repository,  "git://github.com/daanforever/webcrawler_rails.git"

set :scm, :git
set :deploy_to, "/opt/capistrano"

role :web, "www.dron.me"
role :app, "www.dron.me"
role :db,  "www.dron.me", :primary => true

