class DashboardController < ApplicationController
  helper_method :stats_percent_isopado, :stats_totals, :stats_fallecidos, :stats_camas
  before_action :load_extras, only: %i[index retrieve_data]
  ## List keys using:
  ## StatSubtype.all.map {|s| [s.stat_type.key, s.key]}.sort

  def index
  end

  def retrieve_data
    PartialSyncJob.perform_later
    flash[:notice] = 'Se están actualizando los datos, <a href="/" class="alert-link">recargue</a> la página dentro de un minuto.'
    render :index
  end

  def stats_totals
    keys = [
      ["personas_hisopadas", "personas_hisopadas_reportados_del_dia_caba"],
      ['casos_residentes', 'casos_confirmados_reportados_del_dia'],
    ]
    stats_for_keys(keys)
  end

  def stats_percent_isopado
    keys = [
      ['personas_hisopadas', '%_positividad_personas_hisopadas_reportadas_del_dia_totales'],
    ]  
    stats_for_keys(keys)
  end

  def stats_fallecidos
    keys = [
      ['casos_residentes', 'fallecidos_reportados_del_dia'],
    ]
    stats_for_keys(keys)
  end

  def stats_camas
    keys = [
      ["ocupacion_de_camas_sistema_publico", "graves_no_arm"],
      ["ocupacion_de_camas_sistema_publico", "graves_arm"],
    ]  
    stats_for_keys(keys)
  end

  private

  def load_extras
    @total_camas_graves = subtype_for("total_de_camas_sistema_publico", "graves").stats.maximum(:value)
    @months = params['months']&.to_i || 2
  end

  def stats_for_keys(keys)
    subtypes = keys.map { |type, subtype| subtype_for(type, subtype) }

    subtypes.map { |subtype|
      { name: subtype.key.titlecase, data: Stat.where('date > ?', @months.months.ago).where(stat_subtype: subtype).order(:date).pluck(:date, :value) }
    }
  end

  def subtype_for(type, subtype)
    StatSubtype.joins(:stat_type).where(stat_type:{ key: type}).find_by(key: subtype)
  end
end
