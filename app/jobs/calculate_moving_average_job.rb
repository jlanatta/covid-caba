class CalculateMovingAverageJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    days = ENV.fetch('AVERAGE_DAYS', '7').to_i - 1
    StatSubtype.order(:key).each do |subtype|
      subtype.stats.where(moving_average: nil).order(:date).each do |stat|
        average = Stat.where(stat_subtype: subtype, date: stat.date - days.days..stat.date).average(:value)
        stat.update!(moving_average: average)
      end
    end
  end
end
