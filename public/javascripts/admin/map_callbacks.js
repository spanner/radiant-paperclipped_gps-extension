// For the simple but really awkward reason that multimap javascripts have no .js suffix, we have to post-load them

var mmscript = null;
function MM_getScripts(apikey) {
  if (mmscript) return;
  var head = document.getElementsByTagName("head")[0];
  mmscript = document.createElement('script');
  mmscript.id = 'mm_script_tag';
  mmscript.type = 'text/javascript';
  mmscript.src = "http://developer.multimap.com/API/maps/1.2/" + apikey;
  head.appendChild(mmscript);
}

// this example sets multimap display defaults
// to prefer OS maps and show both map-chooser and zoom widgets 

function MM_setupRouteMap(mapviewer) {
  MMDataResolver.setDataPreferences(MM_WORLD_MAP, [904]);
  mapviewer.addWidget(new MMSmallPanZoomWidget());
  mapviewer.addWidget(new MMMapTypeWidget());
}

function MM_showRouteMap (mapviewer, url) {
  var request = mapviewer.getXMLHTTPRequest();
  request.open( 'GET', url, true );
  request.onreadystatechange = function() { MM_showRoute(mapviewer, request); };
  request.send(null);
}

// this is the multimap callback that turns GPX points into a polyline and overlays it

function MM_showRoute(mapviewer, request) {
  if( request.readyState == 4 ) {
    if( request.status == 200 ) {
      var xmlText = request.responseText;
      var xmlDoc = mapviewer.parseXML( xmlText );
      var markers = xmlDoc.documentElement.getElementsByTagName( 'trkpt' );
      var points = [];
      for( var i = 0; i < markers.length && i < 1000; ++i ) {
        var point = new MMLatLon(
        parseFloat(markers[i].getAttribute('lat')),
        parseFloat(markers[i].getAttribute('lon')) );
        points.push( point );
      }
      polyline = new MMPolyLineOverlay( points, undefined, 0.4, 1, false, undefined );
      var location = mapviewer.getAutoScaleLocation( points );
      mapviewer.goToPosition( location );
      mapviewer.addOverlay(polyline);
    }
  }
}
