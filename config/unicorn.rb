root = "/home/deployer/apps/codemarks/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn_err.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.codemarks.sock"
worker_processes 4
timeout 30
