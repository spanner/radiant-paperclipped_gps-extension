module RouteHelper

  def self.included(base)
    base.module_eval {
      
      def map_for(asset)
        if asset.route?
          result = ""
          if Radiant::Config['assets.routes.mm_api_key']
            include_javascript "http://developer.multimap.com/API/maps/1.2/#{Radiant::Config['assets.routes.mm_api_key']}"
            include_javascript 'mm_routes'
            result << %{
<div id="mapviewer_#{asset.id}" style="width: 600px; height: 400px;"></div>
<script type="text/javascript">
  <!-- 
  //<![CDATA[
  function loadmap_#{asset.id}() {
      var mapviewer = new MultimapViewer( document.getElementById( 'mapviewer_#{asset.id}' ) );
      MMDataResolver.setDataPreferences(MM_WORLD_MAP, [904]);
      mapviewer.addWidget(new MMSmallPanZoomWidget());
      mapviewer.setAllowedZoomFactors(13, 15);
      var request = mapviewer.getXMLHTTPRequest();
      request.open( 'GET', '#{asset.thumbnail(:gpx)}', true );
      request.onreadystatechange = MM_showGPX(request, mapviewer);
      request.send(null);
  }
  MMAttachEvent( window, 'load', loadmap_#{asset.id} );
  //]]>
  // -->
</script>
            }
          elsif Radiant::Config['assets.routes.google_api_key']
            
            
            
            
            
          end
          result

        end
      end

    }
  end
  
end
