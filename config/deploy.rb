# config valid only for current version of Capistrano
lock '3.6.0'
# application name
set :application, 'achieve'
# git repository to be cloned (xxxxxxxx: username, yyyyyyyy: application name)
set :repo_url, 'https://github.com/nzerobe/aws_task_by_rob'
# deploy branch name
set :branch, ENV['BRANCH'] || 'master'
# Specify the deploy destination directory
set :deploy_to, '/var/www/achieve'
# Symbolic link settings
set :linked_files, %w{.env config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}
# Number of versions to keep (※mentioned later)
set :keep_releases, 5
# Ruby version
set :rbenv_ruby, '2.5.1'
set :rbenv_type, :system
# Level of log to output. Set to: debug if you want to see the error log in detail.
# Set to: info if it is for a production environment.
set :log_level, :info
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end
  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end