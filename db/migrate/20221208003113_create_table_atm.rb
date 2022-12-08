class CreateTableAtm < ActiveRecord::Migration[7.0]
  def change
    create_table :table_atms do |t|
      t.integer :money, default: 0
      t.timestamps
    end
  end
end
