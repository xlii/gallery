set :bundle_cmd, "/home/fortito/.gems/bin/bundle"

require 'bundler/capistrano'

default_run_options[:pty] = true

# be sure to change these
set :user, 'fortito'
set :domain, 'celsoelucia.fortito.com.br'
set :application, 'gallery'

# the rest should be good
set :repository,  "git://github.com/xlii/#{application}.git"
set :deploy_to do
  "/home/#{user}/apps/#{domain}"
end
set :deploy_via, :remote_cache
set :scm, 'git'

set :branch do
  # default_tag = `git tag`.split("\n").last
  default_tag = 'master'

  tag = Capistrano::CLI.ui.ask "Version to deploy (if is a tag make sure to push it first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end

set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web
role :db, domain, :primary => true

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end