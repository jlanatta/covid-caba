class CreateStatSubtypes < ActiveRecord::Migration[6.1]
  def change
    create_table :stat_subtypes do |t|
      t.string :key
      t.references :stat_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
