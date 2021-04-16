require 'redis'
require 'resque/tasks'
require 'resque/scheduler/tasks'

task 'resque:preload' => :environment

namespace :resque do
  task setup: :environment do
    require 'resque'
  end

  task setup_schedule: :setup do
    require 'resque-scheduler'
  end

  task scheduler: :setup_schedule
end
