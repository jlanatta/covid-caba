class CreateStatTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :stat_types do |t|
      t.string :key

      t.timestamps
    end
  end
end
