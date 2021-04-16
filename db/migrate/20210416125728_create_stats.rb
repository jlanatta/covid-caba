class CreateStats < ActiveRecord::Migration[6.1]
  def change
    create_table :stats do |t|
      t.date :date
      t.string :name
      t.references :stat_subtype, null: false, foreign_key: true
      t.float :value
      t.date :process_date
      t.integer :process_identifier

      t.timestamps
    end
  end
end
