
application_dir="/opt/apps/webcrawler_rails/development/current/"

worker_processes 2
working_directory application_dir

preload_app true

timeout 30

listen "127.0.0.1:3003"

pid "#{application_dir}tmp/pids/unicorn.pid"

stderr_path "#{application_dir}log/unicorn.stderr.log"
stdout_path "#{application_dir}log/unicorn.stdout.log"

before_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.establish_connection
end

