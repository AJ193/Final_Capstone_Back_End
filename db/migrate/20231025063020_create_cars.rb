class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :model
      t.integer :year
      t.string :picture

      t.timestamps
    end
  end
end
