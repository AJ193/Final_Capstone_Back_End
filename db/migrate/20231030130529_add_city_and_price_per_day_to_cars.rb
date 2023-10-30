class AddCityAndPricePerDayToCars < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :city, :string
    add_column :cars, :price_per_day, :integer
  end
end
