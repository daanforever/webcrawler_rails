worker_processes 2
working_directory "."

preload_app true

timeout 30

listen "./tmp/sockets/unicorn.sock", :backlog => 64

pid "./tmp/pids/unicorn.pid"

stderr_path "./log/unicorn.stderr.log"
stdout_path "./log/unicorn.stdout.log"

before_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
    defined?(ActiveRecord::Base) and
        ActiveRecord::Base.establish_connection
end

