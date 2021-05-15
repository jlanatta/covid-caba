class CalculateMovingAverageJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # max_date = Stat.maximum(:date)
    StatSubtype.order(:key).each do |subtype|
      Rails.logger.info("Calculating moving average for #{subtype.key}")
      subtype.stats.where(moving_average: nil).order(:date).each do |stat|
        average = Stat.where(stat_subtype: subtype, date: stat.date - 4.days..stat.date).average(:value)
        stat.update!(moving_average: average)
      end
    end
  end
end
