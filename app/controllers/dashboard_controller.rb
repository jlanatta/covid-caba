class DashboardController < ApplicationController
  helper_method :stats_percent_isopado, :stats_totals, :stats_fallecidos

  ## List keys using:
  ## StatSubtype.all.map {|s| [s.stat_type.key, s.key]}.sort

  def index
    @start_date = 2.months.ago
  end

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
    subtypes = keys.map { |type, subtype| StatSubtype.joins(:stat_type).where(stat_type:{ key: type}).find_by(key: subtype) }

    subtypes.map { |subtype|
      { name: subtype.key.titlecase, data: Stat.where(stat_subtype: subtype).order(:date).pluck(:date, :value) }
    }
  end
end
