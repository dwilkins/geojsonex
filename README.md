#  GeoJSONEx - Explore US States with Census Data formatted as GeoJSONEx

## Demo
There's probably a demo running on http://geojsonex.railsit.com unless something has gone awry

## What it does
 * loads the ascii data from the (2000 US Census)[https://www.census.gov/geo/cob/bdy/co/co00ascii/co99_d00_ascii.zip] ascii file and into a MySQL database
 * Presents some read-only URLs for pulling State and County data as GeoJSON
 * Displays those things with (OpenLayers)[http://openlayers.org/] and (Twiter Bootstrap)[http://twitter.github.io/bootstrap/]

## How to get it going..
 * clone it
 * bundle
 * edit config/database.yml with your information
 * rake db:create db:migrate
 * rake import:state
 * rake import:county
 * rails s
 * PROFIT!

## TODO
 * Make it pretty
 * Upgrade to 2010 Census Data
 * Make it fetch the data from the interwebs instead of having it lie about in the /public directory
 * Make it pretty
 * Integrate with some OpenStreetMap Data for POI's and such
 * User entered POIs
 * Maybe integrate with OpenStreetMap traces and such
 * ???
