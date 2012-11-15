set :application, "gbra"

role :app, "gbra.rocketsurgeryllc.com"
role :web, "gbra.rocketsurgeryllc.com"
role :db,  "gbra.rocketsurgeryllc.com", :primary => true

set :rails_env, "staging"
set :deploy_to, "/var/www/rails/#{application}"

load 'deploy/assets'
load "config/db"
require 'bundler/capistrano'
require "capistrano-unicorn"

require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.9.3-p194@obra-staging'

set :scm, "git"
set :repository, "git@github.com:highgroove/racing_on_rails.git"
set :branch, "master"

set :deploy_via, :remote_cache
set :keep_releases, 5

set :user, "app"
set :use_sudo, false
set :scm_auth_cache, true

namespace :deploy do
  task :symlinks do
    run <<-CMD
      rm -rf #{latest_release}/tmp/pids &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
      rm -rf #{latest_release}/tmp/sockets &&
      ln -s #{shared_path}/sockets #{latest_release}/tmp/sockets
    CMD
  end

  task :copy_cache, :roles => :app do
    %w{ bar bar.html events export people index.html results results.html teams teams.html }.each do |cached_path|
      run("if [ -e \"#{previous_release}/public/#{cached_path}\" ]; then cp -pr #{previous_release}/public/#{cached_path} #{release_path}/public/#{cached_path}; fi") rescue nil
    end
  end

  namespace :web do
    desc "Present a maintenance page to visitors"
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      run "if [ -f #{previous_release}/public/maintenance.html ]; then cp #{previous_release}/public/maintenance.html #{shared_path}/system/maintenance.html; fi"
      run "if [ -f #{previous_release}/local/public/maintenance.html ]; then cp #{previous_release}/local/public/maintenance.html #{shared_path}/system/maintenance.html; fi"
    end
  end

  task :start, :roles => :app do
    top.unicorn.start
  end

  task :stop, :roles => :app do
    top.unicorn.graceful_stop
  end
  
  task :symlinks do
    run <<-CMD
      rm -rf #{latest_release}/tmp/pids &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids &&
      rm -rf #{latest_release}/tmp/sockets &&
      ln -s #{shared_path}/sockets #{latest_release}/tmp/sockets
    CMD
  end

  task :copy_cache, :roles => :app do
    %w{ bar bar.html events export people index.html results results.html teams teams.html }.each do |cached_path|
      run("if [ -e \"#{previous_release}/public/#{cached_path}\" ]; then cp -pr #{previous_release}/public/#{cached_path} #{release_path}/public/#{cached_path}; fi") rescue nil
    end
  end

  namespace :web do
    desc "Present a maintenance page to visitors"
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      run "if [ -f #{previous_release}/public/maintenance.html ]; then cp #{previous_release}/public/maintenance.html #{shared_path}/system/maintenance.html; fi"
      run "if [ -f #{previous_release}/local/public/maintenance.html ]; then cp #{previous_release}/local/public/maintenance.html #{shared_path}/system/maintenance.html; fi"
    end
  end

  task :start, :roles => :app do
    top.unicorn.start
  end

  task :stop, :roles => :app do
    top.unicorn.graceful_stop
  end

  

  

end

after "deploy:update_code", "deploy:symlinks", "deploy:copy_cache", "deploy:migrate"
