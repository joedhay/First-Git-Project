set :application, "First-Git-Project"
set :repository,  "https://github.com/joedhay/First-Git-Project"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


set :user, "joedhay"
#set :use_sudo, false
set :deploy_to, "192.168.1.101/var/www/#{application}"
set :deploy_via, :remote_cache


role :web, "192.168.1.101/var/www/First-Git-Project"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.101/var/www/First-Git-Project"                          # This may be the same as your `Web` server
role :db,  "192.168.1.101/var/www/First-Git-Project", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

#after "deploy", "deploy:bundle_gems"
#after "deploy:bundle_gems", "deploy:restart"

namespace :deploy do
   task :bundle_gems do
      run "cd #{deploy_to}/current && bundle install vendor/gems"
   end

   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end