require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (http://rvm.io)

set :domain, 'yafeilee.me'
set :deploy_to, '/home/ruby/lina_example'
set :repository, 'git@github.com:windy/lina_example.git'
set :branch, 'master'
set :app_path, "#{deploy_to}/#{current_path}"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/application.yml', 'log', 'tmp' ]

set :user, 'ruby'    # Username in the server to SSH to.

task :environment do
  invoke :'rvm:use[2.0.0]'
end

task :setup => :environment do
  ['log', 'tmp'].each do |dir|
    queue! %[mkdir -p "#{deploy_to}/shared/#{dir}"]
    queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/#{dir}"]
  end

  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[mkdir -p "#{deploy_to}/shared/log/"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end

namespace :unicorn do
  set :unicorn_pid, "#{app_path}/tmp/pids/unicorn_lina_example.pid"
  set :start_unicorn, %{
    cd #{app_path} && bundle exec unicorn -c config/unicorn/#{rails_env}.rb -E #{rails_env} -D
  }

#                                                                    Start task
# ------------------------------------------------------------------------------
  desc "Start unicorn"
  task :start => :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! start_unicorn
  end

#                                                                     Stop task
# ------------------------------------------------------------------------------
  desc "Stop unicorn"
  task :stop do
    queue 'echo "-----> Stop Unicorn"'
    queue! %{
      mkdir -p "#{app_path}/tmp/pids"
      test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && rm -rf "#{unicorn_pid}" && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    }
  end

#                                                                  Restart task
# ------------------------------------------------------------------------------
  desc "Restart unicorn using 'upgrade'"
  task :restart => :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end

desc "Shows logs."
task :logs do
  queue %[cd #{deploy_to!}/current && tail -f log/production.log]
end
