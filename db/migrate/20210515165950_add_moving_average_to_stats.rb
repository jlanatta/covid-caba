class AddMovingAverageToStats < ActiveRecord::Migration[6.1]
  def change
    add_column :stats, :moving_average, :float
  end
end
