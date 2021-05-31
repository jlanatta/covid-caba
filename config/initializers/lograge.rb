require 'lograge/sql/extension'

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.keep_original_rails_log = true
  # config.lograge.base_controller_class = 'ActionController::Base'
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.custom_options = lambda do |event|
    { time: event.time }
  end
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host
    }
  end

  config.lograge_sql.keep_default_active_record_log = true
  # Instead of extracting event as Strings, extract as Hash. You can also extract
  # additional fields to add to the formatter
  config.lograge_sql.extract_event = Proc.new do |event|
    { name: event.payload[:name], duration: event.duration.to_f.round(2), sql: event.payload[:sql] }
  end
  # Format the array of extracted events
  config.lograge_sql.formatter = Proc.new do |sql_queries|
    sql_queries
  end
end