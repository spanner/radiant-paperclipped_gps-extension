module GpsHelper

  def self.included(base)
    base.module_eval {
      
      def map_for(asset)
        result = " map_for: "
        if asset.track?
          result = " track: "
          if Radiant::Config['assets.gps.mm_api_key']
            result = " multimap: "
            include_javascript "http://developer.multimap.com/API/maps/1.2/#{Radiant::Config['assets.gps.mm_api_key']}"
            include_javascript 'admin/map_callbacks'
            result << %{
<div id="mapviewer_#{asset.id}" class="mapviewer" style="width: 100%; height: 500px;"></div>
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
          elsif Radiant::Config['assets.gps.google_api_key']
            result << %{<p>Sorry. Google maps don't work yet.</p>}
          else
            result << %{<p>Map rendering requires either a Multimap (define setting <em>assets.gps.mm_api_key</em>) or a Google Maps API key (define setting <em>assets.gps.google_api_key</em>).</p>}
          end
        else
          result << %{<p>Asset <strong>#{asset.name}</strong> is not a GPS file</p>}
        end
        result
      end

    }
  end
  
end
