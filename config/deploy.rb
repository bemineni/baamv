set :rails_root, "#{File.dirname(__FILE__)}/.."  #get rails root

require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require "bundler/capistrano"
# Disbale this if you are deploying for the first time
load 'deploy/assets'

set :application, "iamzero"
set :rvm_ruby_string, '1.9.3'        # Or whatever env you want it to run in.

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:bemineni/baamv.git"  # Your clone URL 
set :scm, "git"
set :user, "iamzero"  # The server's user for deploys

ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "#{application}")]
set :branch, "new_ui"
set :deploy_via, :remote_cache
set :deploy_to, "/web_apps/#{application}"
set :host_header, "iamzero.in"
set :use_sudo, false
set :fresh_install, false

require "#{rails_root}/lib/unicorn/capistrano"
require "#{rails_root}/lib/nginx/capistrano"


set :amazonaws, fetch(:amazonaws,"ec2-23-20-253-249.compute-1.amazonaws.com")

role :web, amazonaws
role :app, amazonaws
role :db,  amazonaws, :primary => true

before "deploy:setup", "deploy:create_release_dir"
namespace :deploy do
  desc "This creates the release directory for the first time setup"
  task :create_release_dir, :except => {:no_release => true} do
    sudo "rm -fr #{deploy_to}"
    sudo "mkdir -p #{deploy_to}"
    sudo "chown -R iamzero:web #{deploy_to}"
    run "mkdir -p #{fetch :releases_path}"
  end
end

namespace :baamv do

  desc 'Deploying baamv for the first time'
  task :new_deploy do
    set :fresh_install,true
    deploy.setup
    # application.rb and checkin
    #The assets:precompile process is part of the deploy.update. Before the precompile process, we will create database.
    deploy.update
    deploy.migrate
    run_seed
    unicorn.reload
  end


  desc 'Load DB schema - CAUTION: rewrites database'
  task :load_schema, :roles => :app do
    if Capistrano::CLI.ui.ask("About to `rake db:schema:load`. Are you sure to wipe the entire database (anything other than 'yes' aborts):") != 'yes'
      raise RuntimeError.new('db:schema:load aborted!')
    end
    run "cd #{release_path}; bundle exec rake db:schema:load RAILS_ENV=#{rails_env}"
  end

  desc 'Create a new database'
  task :create_database, :roles => :app do
     if fresh_install 
        run "cd #{release_path}; bundle exec rake db:create RAILS_ENV=#{rails_env}"
      end
  end

  desc 'Seed data'
  task :run_seed, :roles => :app do
      #copy geolite from the lib/geolite.Please see that we update this 
      #frequently from http://geolite.maxmind.com/download/geoip/database/GeoLiteCity_CSV/GeoLiteCity-latest.zip
      path = current_path
      path ||= release_path
      run "cd #{path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  desc 'Generate deployment timestamp'
  task :generate_timestamp, :roles => :app do
    path = current_path
    path ||= release_path
    run "cd #{path};bundle exec rake util:generate_timestamp RAILS_ENV=#{rails_env}"
  end

  desc 'Clean complete database. This will remove all the records'
  task :clean_database, :roles => :app do
      path = current_path
      path ||= release_path
     run "cd #{path};bundle exec rake util:clean_database RAILS_ENV=#{rails_env}"
  end

  desc "Create photos upload symlink"
  task :symlink ,:roles => :app do
    path = current_path
    path ||= release_path
    run "rm -rf #{path}/public/uploads"
    run "mkdir -p #{shared_path}/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end


end

before 'unicorn:reload' , 'baamv:generate_timestamp'
after "deploy:update_code", "baamv:symlink"
before "deploy:assets:precompile" , "baamv:create_database"
#Name space ends here

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end


def process_exists?(pid_file)
    capture("ps -p $(cat #{pid_file}) ; true").strip.split("\n").size == 2
end

#disable this is you are deploying for the first time.
#snippet to ease the deployment of assets
# namespace :deploy do
#    namespace :assets do
#      task :precompile, :roles => :web, :except => { :no_release => true } do
#        #get the latest revision of the assets folder to check if it needs deployed again
#        from = source.next_revision(current_revision)
#        if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
#          run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#        else
#          logger.info "Skipping asset pre-compilation because there were no asset changes"
#        end
#      end
#    end
#  end
