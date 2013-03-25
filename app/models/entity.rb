class Entity < ActiveRecord::Base
  attr_accessible :entity_name, :entity_parent_id, :entity_type, :fips_code, :lasd, :lasd_translation
  has_many :entity_boundaries, :order => 'id asc'
  has_one :parent, primary_key: :entity_parent_id,foreign_key: :id, class_name: 'Entity'
  has_many :children, primary_key: :id,foreign_key: :entity_parent_id, class_name: 'Entity', order: :entity_name

  def to_geojson
    GeoJSON.from_entities(self).to_json
  end


end
