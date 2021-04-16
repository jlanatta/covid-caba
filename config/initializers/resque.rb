# frozen_string_literal: true

require 'redis'
require 'resque/scheduler/server'
require 'resque/failure/redis'

Resque.redis = Redis.new(url: ENV['REDIS_URL'])
Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.logger.level = Logger::INFO
