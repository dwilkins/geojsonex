class AddCacheToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :geojson_cache, :longtext
  end
end
