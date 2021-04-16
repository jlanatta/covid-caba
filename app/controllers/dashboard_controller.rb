class DashboardController < ApplicationController
  helper_method :stats_percent_isopado, :stats_totals, :stats_fallecidos, :stats_camas

  ## List keys using:
  ## StatSubtype.all.map {|s| [s.stat_type.key, s.key]}.sort

  def index
    subtype = subtype_for("total_de_camas_sistema_publico", "graves")
    @total_camas_graves = subtype.stats.maximum(:value)
    @months = 3
  end

  def stats_camas
    keys = [
      ["ocupacion_de_camas_sistema_publico", "graves_arm"],
      ["ocupacion_de_camas_sistema_publico", "graves_no_arm"],
    ]
    stats_for_keys(keys)
  end
  
  # ["total_de_camas_sistema_publico", "leves_hoteles_hospitales"],
  # ["total_de_camas_sistema_publico", "moderados"],

  def stats_percent_isopado
    keys = [
      ['personas_hisopadas', '%_positividad_personas_hisopadas_reportadas_del_dia_totales'],
    ]
    stats_for_keys(keys)
  end

  def stats_totals
    keys = [
      ['casos_residentes', 'casos_confirmados_reportados_del_dia'],
    ]
    stats_for_keys(keys)
  end

  def stats_fallecidos
    keys = [
      ['casos_residentes', 'fallecidos_reportados_del_dia'],
    ]
    stats_for_keys(keys)
  end

  private

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
