class CreateEntityBoundaries < ActiveRecord::Migration
  def change
    create_table :entity_boundaries do |t|
      t.integer :entity_id
      t.boolean :starting_point
      t.decimal :lat, precision: 18, scale: 12
      t.decimal :lng, precision: 18, scale: 12

      t.timestamps
    end
  end
end
