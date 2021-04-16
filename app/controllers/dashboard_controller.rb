class DashboardController < ApplicationController
  def index
    
  end

  def update_data
    url = 'https://cdn.buenosaires.gob.ar/datosabiertos/datasets/salud/reporte-covid/dataset_reporte_covid_sitio_gobierno.csv'
    response = HTTParty.get(url)
    csv = response.parsed_response
    csv.shift #remove headers
    start = Date.parse('1/1/2021')

    Stat.delete_all
    StatSubtype.delete_all
    StatType.delete_all

    csv.each do |row|
      date = Date.parse(row[0][0,9])
      next if date < start

      type = StatType.find_or_create_by(key: row[2])
      subtype = StatSubtype.find_or_create_by(stat_type: type, key: row[3])
      
      value = Float(row[4])

      process_date = Date.parse(row[5][0,9])
      process_identifier = Integer(row[6])
      Stat.create!(date: date, stat_subtype: subtype, value: value, process_date: process_date, process_identifier: process_identifier)
    end

    render 'index'
  end
end
