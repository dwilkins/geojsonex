var map, layer, styleMap, data_url, data_name, vectors;
// OpenLayers.ProxyHost = "/";

function map_init() {
    if(data_url != undefined) {
     return
    }
    data_url = $("#map").attr("data-url");
    data_name = $("#map").attr("data-name");
    map = new OpenLayers.Map({
        div: "map",
        projection: new OpenLayers.Projection("EPSG:900913"),
        displayProjection: new OpenLayers.Projection("EPSG:4326"),
	controls:[
	    new OpenLayers.Control.Navigation(),
	    new OpenLayers.Control.PanZoomBar(),
	    new OpenLayers.Control.LayerSwitcher(),
	    new OpenLayers.Control.Attribution()],
        units: "m",
        allOverlays: true,
        maxResolution: 156543.0339,
        maxExtent: new OpenLayers.Bounds(
            -20037508, -20037508, 20037508, 20037508
        )
    });



    var mapnik = new OpenLayers.Layer.OSM.Mapnik("Mapnik");

    var wms = new OpenLayers.Layer.WMS( "OpenLayers WMS",
                                        "http://vmap0.tiles.osgeo.org/wms/vmap0?", {layers: 'basic'});

    // prepare to style the data
    styleMap = new OpenLayers.StyleMap({
        strokeColor: "black",
        strokeWidth: 2,
        strokeOpacity: 0.5,
        fillOpacity: 0.2
    });

    // create a color table for state FIPS code
    var colors = ["red", "orange", "yellow", "green", "blue", "purple"];
    var code, fips = {};
    for(var i=1; i<=66; ++i) {
        code = "0" + i;
        code = code.substring(code.length - 2);
        fips[code] = {fillColor: colors[i % colors.length]};
    }
    layer_protocol =  new OpenLayers.Protocol.HTTP(
        {
            url:  data_url,
            format: new OpenLayers.Format.GeoJSON(
                {
                    ignoreExtraDims: true,
                    externalProjection: new OpenLayers.Projection("EPSG:4326"),
                    internalProjection: new OpenLayers.Projection("EPSG:900913")
                }),
            callback: function(response) {
                var pnt = response.features[0].geometry.getCentroid();
                lonLat = new OpenLayers.LonLat(pnt.x,pnt.y);
                map.setCenter (lonLat);
                map.zoomToExtent(response.features[0].geometry.getBounds(),false);
            }

        });
    layer_protocol.read();
    layerformat = new OpenLayers.Format.GeoJSON();
    // create a vector layer using the canvas renderer (where available)
    vectors = new OpenLayers.Layer.Vector(data_name,
                                          {
                                              strategies: [new OpenLayers.Strategy.Fixed()],
                                                  protocol: layer_protocol
                                          });

    var options = {
        hover: false,
        onSelect: onFeatureSelect
    };
// ***** Change the layers that are displayed
    map.addLayers([mapnik,vectors]);
    var select = new OpenLayers.Control.SelectFeature(vectors, options);
    var drag = new OpenLayers.Control.DragFeature(vectors, options);


// ***** Comment out these lines to disable dragging
//    map.addControl(select);
//    map.addControl(drag);
//    select.activate();
//    drag.activate();

}
var selectedFeature = null;
function onFeatureSelect(feature) {
    var notification = document.getElementById('notification');
    notification.innerHTML = feature.data.state_name;
//    return;
    if(selectedFeature != null && selectedFeature.popup != undefined) {
        selectedFeature.popup.destroy();
    }
    selectedFeature = feature;
    popup = new OpenLayers.Popup.AnchoredBubble("chicken",
                                             feature.geometry.getBounds().getCenterLonLat(),
                                             null,
                                             "<div style='font-size:.8em'>" + feature.data.county_name +"</div>",
                                             null, true);
    feature.popup = popup;
    map.addPopup(popup);
}

var loaded_features = new Object();

function display_feature() {
    var fetch_url = $(this).attr('data-url');
    if ($(this).parent().hasClass('selected')) {
        $(this).parent().removeClass('selected');
        vectors.removeFeatures(loaded_features[fetch_url].features);
        loaded_features[fetch_url] = undefined;
        return;
    }
    $(this).parent().addClass('selected');
    var feature_protocol = new OpenLayers.Protocol.HTTP(
            {
                url:  fetch_url,
                format: new OpenLayers.Format.GeoJSON(
                    {
                        ignoreExtraDims: true,
                        externalProjection: new OpenLayers.Projection("EPSG:4326"),
                        internalProjection: new OpenLayers.Projection("EPSG:900913")
                    }),
                callback: function(response) {
                    vectors.addFeatures(response.features)
                }
            });
    loaded_features[fetch_url] = feature_protocol.read();
    return false;
}



$().ready( function () {
    $("a.county").click(display_feature);
    map_init();
   });
