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
<div id="mapviewer_#{asset.id}" class="mapviewer" style="width: 760px; height: 500px;"></div>
<script type="text/javascript">
  <!-- 
  //<![CDATA[
    function loadmap_#{asset.id}() {
        var mapviewer = new MultimapViewer( document.getElementById( 'mapviewer_#{asset.id}' ) );
        mapviewer.addWidget(new MMSmallPanZoomWidget());
        mapviewer.setAllowedZoomFactors(13, 15);
        MM_setupRouteMap(mapviewer, '#{asset.thumbnail(:gpx)}');
        MM_showRouteMap(mapviewer);
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
