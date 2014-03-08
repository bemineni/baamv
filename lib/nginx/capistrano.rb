Capistrano::Configuration.instance(:must_exist).load do
  
  namespace :nginx do
  
    desc "Prepares nginx server config files for the current application before deploy:setup and deploy"
    task :setup, :roles => :web, :except => { :no_release => true } do
      # generate upstream file
      server_content = <<-CONTENT
        upstream #{application} {
          server unix:/tmp/.sock_#{application} fail_timeout=0;
        }
        
        server {
          listen 80 default deferred; # for Linux

          client_max_body_size 4G;
          server_name #{host_header};
          
          keepalive_timeout 5;

          # path for static files
          root #{current_path}/public;

          try_files $uri/index.html $uri.html $uri @app;

          location @app {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            
            proxy_set_header Host $http_host;
            
            proxy_redirect off;

            proxy_pass http://#{application};
          }

          # Rails error pages
          error_page 500 502 503 504 /500.html;
          location = /500.html {
            root #{current_path}/public;
          }
        }

      CONTENT
      
      File.open("./config/nginx_server.conf", 'w') { |f| f.write(server_content) }           
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
    set :app_env, "production"
    set :nginx_service, "nginx"

    desc 'Start Nginx'
    task :start, :roles => :app, :except => {:no_release => true} do
          logger.important("Starting...", "Nginx")
          sudo "service #{nginx_service} start"      
    end


    desc 'Stop Nginx'
    task :stop, :roles => :app, :except => {:no_release => true} do
          logger.important("Stopping...", "Nginx")
          sudo "service #{nginx_service} stop"
    end

  
    desc 'Reload Nginx'
    task :reload, :roles => :app, :except => {:no_release => true} do
      
        logger.important("Restarting...", "Nginx")
        sudo  "service #{nginx_service} restart"  
  end

  
  # add in hooks to run tasks at appropriate times
  #after 'deploy', 'unicorn:clear_cache'
 after 'unicorn:setup', 'nginx:setup'
 after 'unicorn:update_confs', 'nginx:update_confs'
 after 'unicorn:reload', 'nginx:reload'
end
end
