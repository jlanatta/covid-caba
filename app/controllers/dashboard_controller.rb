class DashboardController < ApplicationController
  helper_method :data_for, :moving_average_data_for
  before_action :load_extras, only: %i[index retrieve_data]

  ## List keys using:
  ## StatSubtype.all.map {|s| [s.stat_type.key, s.key]}.sort
  160.72.67.250
  def index; end

  def retrieve_data
    PartialSyncJob.perform_later
    flash[:notice] =
      'Se están actualizando los datos, <a href="/" class="alert-link">recargue</a> la página dentro de un minuto.'
    render :index
  end

  private

  def load_extras
    @total_camas_graves = subtype_for('total_de_camas_sistema_publico', 'graves').stats.maximum(:value)

    @months = params['months']&.to_i || 2
    @average_days = ENV.fetch('AVERAGE_DAYS', '7').to_i
  end

  def data_for(type, subtype)
    base_data_for type, subtype, :value
  end

  def moving_average_data_for(type, subtype)
    base_data_for type, subtype, :moving_average
  end

  def base_data_for(type, subtype, field)
    subtype = subtype_for(type, subtype)
    data = Stat.where('date > ?', @months.months.ago).where(stat_subtype: subtype).order(:date).pluck(:date, field)
    data = data.map { |date, value| "{x: '#{date}', y: #{value}}" }
    data.join(',').html_safe
  end

  def subtype_for(type, subtype)
    StatSubtype.joins(:stat_type).where(stat_type: { key: type }).find_by(key: subtype)
  end
end
