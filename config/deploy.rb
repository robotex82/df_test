set :application, "df_test"

default_run_options[:pty]   = true  # Must be set for the password prompt from git to work
ssh_options[:forward_agent] = true  # Use local ssh keys
set :repository,  "git@github.com:robotex82/df_test.git"
set :branch, "master"
set :deploy_via, :remote_cache


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "robotex.de"                   # Your HTTP server, Apache/etc
role :app, "robotex.de"                   # This may be the same as your `Web` server
role :db,  "robotex.de", :primary => true # This is where Rails migrations will run

set :user, "ssh-314975-ssh" # DomainFactory SSH User: ssh-xxxxxx-???
set :password, "AI1cXlm1"   # DomainFactory SSH Password
set :use_sudo, false        # Don't use sudo

# Deployment path on DomainFactory:
# /kunden/xxxxxx_xxxxx/foo_app
set :deploy_to, "/kunden/314975_60439/blog/production"

after "deploy:symlink", "/kunden/314975_60439/df_test/production"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  
  desc "Restart the server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{current_path}/tmp/restart.txt"
  end
end

namespace :bundle do
  desc "Install bundle to ~/.gem without development and test"
  task :install, :roles => :app do
    run <<-CMD
      cd #{current_path}; bundle install --path=~/.gem --without development test
    CMD
  end
  
  desc "Symlinks your machine specific bundle to your rails app"
  task :symlink, :roles => :app do
    run <<-CMD
      mkdir #{shared_path}/.bundle
      ln -nfs #{shared_path}/.bundle #{release_path}/.bundle
    CMD
  end
end

namespace :domain_factory do
  desc "Symlinks the domain factory mysql gem to your gem path"
  task :copy_mysql_gem, :roles => :app do
    run <<-CMD
      mkdir /kunden/314975_60439/.gem/gems
      cd /kunden/314975_60439/.gem/gems
      rm -rf ./mysql-2.7
      
      ln -nfs /usr/lib/ruby/gems/1.8/gems/mysql-2.7 /kunden/314975_60439/.gem/gems/mysql-2.7
    CMD
  end
end

