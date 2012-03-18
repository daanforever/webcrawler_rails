APP_PATH='/opt/capistrano/current'.freeze

worker_processes 2
working_directory "#{APP_PATH}"

preload_app true

timeout 30

listen "#{APP_PATH}/tmp/sockets/unicorn.sock", :backlog => 64

pid "#{APP_PATH}/tmp/pids/unicorn.pid"

stderr_path "#{APP_PATH}/log/unicorn.stderr.log"
stdout_path "#{APP_PATH}/log/unicorn.stdout.log"

before_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.establish_connection
end

