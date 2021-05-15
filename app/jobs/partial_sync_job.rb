class PartialSyncJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    max_date = Stat.maximum(:date)

    Rails.logger.info('Downloading data file')
    response = HTTParty.get(ENV.fetch('DATA_FILE_URL'))
    Rails.logger.info('Data file downloaded, processing...')
    csv = response.parsed_response
    csv.shift # remove headers

    csv.each do |row|
      date = Date.parse(row[0][0, 9])
      next unless date > max_date

      type = StatType.find_or_create_by(key: row[2])
      subtype = StatSubtype.find_or_create_by(stat_type: type, key: row[3])
      value = Float(row[4])
      process_date = Date.parse(row[5][0, 9])
      process_identifier = Integer(row[6])

      Stat.create!(date: date, stat_subtype: subtype, value: value, process_date: process_date,
                   process_identifier: process_identifier)
      Rails.logger.info('Stat created!')
    end

    CalculateMovingAverageJob.perform_later

    Rails.logger.info('Data file processed!')
  end
end
