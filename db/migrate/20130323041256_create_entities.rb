class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :fips_code, limit: 4
      t.string :entity_name, limit: 40
      t.string :entity_type, limit: 20
      t.integer :entity_parent_id
      t.string :lasd, limit: 4
      t.string :lasd_translation, limit: 50

      t.timestamps
    end
  end
end
