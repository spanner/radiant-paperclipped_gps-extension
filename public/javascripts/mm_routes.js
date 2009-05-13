// this is the multimap callback that turns GPX points into a polyline and overlays it

function MM_showGPX() {
  if( request.readyState == 4 ) {
    if( request.status == 200 ) {
      var xmlText = request.responseText;
      var xmlDoc = mapviewer.parseXML( xmlText );
      var markers = xmlDoc.documentElement.getElementsByTagName( 'rtept' );
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
    } else {
      alert( 'There was a problem making the XML request - please use the contact form to let us know.' );
    }
  }
}
