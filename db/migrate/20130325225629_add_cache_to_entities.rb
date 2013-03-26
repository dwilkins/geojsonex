class AddCacheToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :geojson_cache, :blob
  end
end
