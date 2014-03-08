Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :unicorn do
  
    desc "Prepares upstream and server config files for the current application before deploy:setup and deploy"
    task :setup, :roles => :web, :except => { :no_release => true } do
      # generate unicorn config
      unicorn_content = <<-CONTENT
        #set up rvm
        APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))

        if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
          begin
            #require 'rvm'
            #RVM.use_from_path! File.dirname(File.dirname(__FILE__))
          rescue LoadError
            raise "RVM ruby lib is currently unavailable."
          end
        end
      
        #set up bundler
        ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
        require 'bundler/setup'
        
        # Use at least one worker per core if you're on a dedicated server,
        # more will usually help for _short_ waits on databases/caches.
        worker_processes 2

        # Since Unicorn is never exposed to outside clients, it does not need to
        # run on the standard HTTP port (80), there is no reason to start Unicorn
        # as root unless it's from system init scripts.
        # If running the master process as root and the workers as an unprivileged
        # user, do this to switch euid/egid in the workers (also chowns logs):
        #user "", ""

        # Help ensure your application will always spawn in the symlinked
        # "current" directory that Capistrano sets up.
        working_directory "#{current_path}" # available in 0.94.0+

        # listen on both a Unix domain socket and a TCP port,
        # we use a shorter backlog for quicker failover when busy
        listen "/tmp/.sock_#{application}", :backlog => 64
        #listen 8080, :tcp_nopush => true

        # nuke workers after 30 seconds instead of 60 seconds (the default)
        timeout 30

        # feel free to point this anywhere accessible on the filesystem
        pid "#{shared_path}/pids/unicorn.pid"

        # By default, the Unicorn logger will write to stderr.
        # Additionally, ome applications/frameworks log to stderr or stdout,
        # so prevent them from going to /dev/null when daemonized here:
        stderr_path "#{shared_path}/log/unicorn.stderr.log"
        stdout_path "#{shared_path}/log/unicorn.stdout.log"

        # combine REE with "preload_app true" for memory savings
        # http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
        preload_app true
        GC.respond_to?(:copy_on_write_friendly=) and
          GC.copy_on_write_friendly = true
        
        before_fork do |server, worker|
          # the following is highly recomended for Rails + "preload_app true"
          # as there's no need for the master process to hold a connection
          defined?(ActiveRecord::Base) and
            ActiveRecord::Base.connection.disconnect!

          # The following is only recommended for memory/DB-constrained
          # installations.  It is not needed if your system can house
          # twice as many worker_processes as you have configured.
          #
          # # This allows a new master process to incrementally
          # # phase out the old master process with SIGTTOU to avoid a
          # # thundering herd (especially in the "preload_app false" case)
          # # when doing a transparent upgrade.  The last worker spawned
          # # will then kill off the old master process with a SIGQUIT.
          old_pid = '#{current_path}/tmp/pids/unicorn.pid.oldbin'
          if File.exists?(old_pid) && server.pid != old_pid
            begin
              Process.kill("QUIT", File.read(old_pid).to_i)
            rescue Errno::ENOENT, Errno::ESRCH
              # someone else did our job for us
            end
          end
          #
          # Throttle the master from forking too quickly by sleeping.  Due
          # to the implementation of standard Unix signal handlers, this
          # helps (but does not completely) prevent identical, repeated signals
          # from being lost when the receiving process is busy.
          # sleep 1
        end

        after_fork do |server, worker|
          # per-process listener ports for debugging/admin/migrations
          # addr = "127.0.0.1:{9293 + worker.nr}"
          # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

          # the following is *required* for Rails + "preload_app true",
          defined?(ActiveRecord::Base) and
            ActiveRecord::Base.establish_connection

          # if preload_app is true, then you may also want to check and
          # restart any other shared sockets/descriptors such as Memcached,
          # and Redis.  TokyoCabinet file handles are safe to reuse
          # between any number of forked children (assuming your kernel
          # correctly implements pread()/pwrite() system calls)
        end
      CONTENT

      File.open("./config/unicorn.rb", 'w') { |f| f.write(unicorn_content) }
          
    end

    desc "Generates content for remote"
    task :update_confs, :roles => :web do
      sudo "ln -s -f #{current_path}/config/nginx_server.conf /etc/nginx/sites-enabled/#{application}.conf"
    end
    
    # Check if remote file exists
    #
    def remote_file_exists?(full_path)
      'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
    end
        
    # Check if process is running
    #
    def process_exists?(pid_file)
      capture("ps -p $(cat #{pid_file}) ; true").strip.split("\n").size == 2
    end

    # Set unicorn vars
    #
    set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
    set :app_env, "production"
    set :config_path, "#{current_path}/config/unicorn.rb"
    set :unicorn_exe, "bundle exec unicorn"

    desc 'Start Unicorn'
    task :start, :roles => :app, :except => {:no_release => true} do
      if remote_file_exists?(unicorn_pid)
        if process_exists?(unicorn_pid)
          logger.important("Unicorn is already running!", "Unicorn")
          next
        else
          run "rm #{unicorn_pid}"
        end
      end
      
      if remote_file_exists?(config_path)
        logger.important("Starting...", "Unicorn")
        run "cd #{current_path} && #{unicorn_exe} -c #{config_path} -E #{app_env} -D"
      else
        logger.important("Config file for \"#{app_env}\" environment was not found at \"#{config_path}\"", "Unicorn")
      end
    end

    desc 'Stop Unicorn'
    task :stop, :roles => :app, :except => {:no_release => true} do
      if remote_file_exists?(unicorn_pid)
        if process_exists?(unicorn_pid)
          logger.important("Stopping...", "Unicorn")
          run "kill `cat #{unicorn_pid}`"
        else
          run "rm #{unicorn_pid}"
          logger.important("Unicorn is not running.", "Unicorn")
        end
      else
        logger.important("No PIDs found. Check if unicorn is running.", "Unicorn")
      end
    end

    desc 'Unicorn graceful shutdown'
    task :graceful_stop, :roles => :app, :except => {:no_release => true} do
      if remote_file_exists?(unicorn_pid)
        if process_exists?(unicorn_pid)
          logger.important("Stopping...", "Unicorn")
          run "kill -s QUIT `cat #{unicorn_pid}`"
        else
          run "rm #{unicorn_pid}"
          logger.important("Unicorn is not running.", "Unicorn")
        end
      else
        logger.important("No PIDs found. Check if unicorn is running.", "Unicorn")
      end
    end

    desc 'Reload Unicorn'
    task :reload, :roles => :app, :except => {:no_release => true} do
      if remote_file_exists?(unicorn_pid)
        logger.important("Stopping...", "Unicorn")
        run "kill -s USR2 `cat #{unicorn_pid}`"
      else
        logger.important("No PIDs found. Starting Unicorn server...", "Unicorn")
        if remote_file_exists?(config_path)
          run "cd #{current_path} && #{unicorn_exe} -c #{config_path} -E #{app_env} -D"
        else
          logger.important("Config file for \"#{app_env}\" environment was not found at \"#{config_path}\"", "Unicorn")
        end
      end
    end
  end

  
  # add in hooks to run tasks at appropriate times
  #after 'deploy', 'unicorn:clear_cache'
 after 'deploy:setup', 'unicorn:setup'
 after 'deploy:setup', 'unicorn:update_confs'
 after 'deploy', 'unicorn:reload'
end
