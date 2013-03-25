# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register 'text/geojson', :geojson
ActionController::Renderers.add :geojson do |object, options|
  self.content_type ||= 'text/geojson'
  self.response_body  = object.respond_to?(:to_geojson) ? object.to_geojson : object
end
