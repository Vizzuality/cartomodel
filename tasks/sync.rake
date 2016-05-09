require 'active_record'
require 'cartomodel/synchronizer'

namespace :cartomodel do
  desc "Sync CartoDB local entities to server"
  task :sync do
    Cartomodel::Synchronizer.sync_all
  end
end
