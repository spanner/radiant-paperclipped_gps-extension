// this example sets multimap display defaults
// to prefer OS maps and show both map-chooser and zoom widgets 

function MM_setupRouteMap(mapviewer, url) {
  MMDataResolver.setDataPreferences(MM_WORLD_MAP, [904]);
  mapviewer.addWidget(new MMSmallPanZoomWidget());
  mapviewer.addWidget(new MMMapTypeWidget());
  mapviewer.setAllowedZoomFactors(13, 15);
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
