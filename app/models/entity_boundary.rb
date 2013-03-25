class EntityBoundary < ActiveRecord::Base
  attr_accessible :entity_id, :lat, :lng, :starting_point
  belongs_to :entity
end
