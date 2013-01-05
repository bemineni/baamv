
require 'capistrano'
require "bundler/capistrano"
# Load RVM's capistrano plugin.    
require "rvm/capistrano"
require 'capistrano/cli'

#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_ruby_string,"1.9.3"
set :deploy_to, "/web_apps/iamzero"
set :application, "iamzero"
set :scm, :git
set :repository,  "git@github.com:bemineni/baamv.git"
set :branch, "master"
set :user , "iamzero"
set :rvm_type, :user
set :scm_passphrase, "srikanth"  # The deploy user's password
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, :production
set :unicorn_binary, "unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :linode, "173.255.227.60"  # The deploy user's password

role :web, linode                        # Your HTTP server, Apache/etc
role :app, linode                          # This may be the same as your `Web` server
role :db,  linode, :primary => true # This is where Rails migrations will run


def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end


def process_exists?(pid_file)
    capture("ps -p $(cat #{pid_file}) ; true").strip.split("\n").size == 2
end



namespace :baamv do

	task :default, :roles => :app do
		deploy.update
		
	end

    desc "Install Boot strap"
	task :bootstrap , :roles => :app do
		run "cd #{deploy_to}/current/ ; rails g  bootstrap:install -f"
	end

	desc "Start nginx server"
	task :nginx_restart , :roles => :app do
		set :sudo_password, proc{ Capistrano::CLI.password_prompt("Type your sudo password #{user}: ") }
#		run "rvmsudo service nginx restart"
		run "/sbin/service --status-all"
	end

	desc "Shows all the files in the directory"
	task :show , :roles => :app do 
		run "ls -al"
	end

	desc "Clear gem lock file"
	task :show , :roles => :app do 
		if remote_file_exists?( "#{deploy_to}/current/Gemfile.lock" )
			 run "rm -fr #{deploy_to}/current/Gemfile.lock"
		end
	end

	desc "Run bundler"
	task :bundler, :roles => :app  do
		run "bundle install"
	end


end




namespace :unicorn do

	task :start, :roles => :app, :except => { :no_release => true } do

		run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"

	end

	task :stop, :roles => :app, :except => { :no_release => true } do

		run "kill `cat #{unicorn_pid}`"

	end

	task :graceful_stop, :roles => :app, :except => { :no_release => true } do

		run "#kill -s QUIT `cat #{unicorn_pid}`"

	end

	task :reload, :roles => :app, :except => { :no_release => true } do

		run "#kill -s USR2 `cat #{unicorn_pid}`"

	end

	task :restart, :roles => :app, :except => { :no_release => true } do

		if remote_file_exists? "#{unicorn_pid}"
			if process_exists? "#{unicorn_pid}"
				stop
			end
		end

		start
	end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end