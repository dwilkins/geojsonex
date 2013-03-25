class GeoJSON
  def self.from_entities(entities)
    entities = entities.is_a?(Array) ? entities : [entities]
    coords_groups = []
    coords = []
    features = []
    entities.each do |entity|
      entity.entity_boundaries.each do |b|
        if (b.starting_point)
          if(coords.length > 0)
            coords_groups << coords
          end
          coords = []
        else
          coords << [b.lng.to_f, b.lat.to_f]
        end
      end
      coords_groups << coords if(coords.length > 0)
      features << {
        properties: {boundary_name: entity.entity_name},
        geometry:
        { type: 'GeometryCollection',
          geometries:
          [
           {
             type: 'Polygon',
             coordinates: coords_groups
           }
          ]
        }
      }
      coords_groups = []
      coords = []
    end
    featurecollection = {type: 'FeatureCollection', features: features}
    return featurecollection
  end

end
