set :deploy_to, "/web_apps/iamzero"
set :application, "baamv"
set :scm, :git
set :repository,  "git@github.com:bemineni/baamv.git"
set :branch, "master"
set :user , "iamzero"
set :scm_passphrase, "sammy"  # The deploy user's password
set :deploy_via, :remote_cache
set :use_sudo, false


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :linode, "173.255.227.60"  # The deploy user's password

role :web, linode                        # Your HTTP server, Apache/etc
role :app, linode                          # This may be the same as your `Web` server
role :db,  linode, :primary => true # This is where Rails migrations will run

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