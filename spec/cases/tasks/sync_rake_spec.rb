require 'spec_helper'
require 'rake'

describe 'Sync task' do
  it 'calls the Synchronizer service' do
    load File.expand_path('../../../../tasks/sync.rake', __FILE__)

    expect(Cartomodel::Synchronizer).to receive(:sync_all)

    Rake::Task['cartomodel:sync'].invoke
  end
end