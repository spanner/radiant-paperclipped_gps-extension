module GpsHelper

  def slidemap_for(asset)
    result = ""
    logger.warn "!   slidemap_for(#{asset.inspect})"
    if asset.gps?
      if Radiant::Config['assets.gps.mm_api_key']
        include_javascript "http://developer.multimap.com/API/maps/1.2/#{Radiant::Config['assets.gps.mm_api_key']}"
        include_javascript 'admin/map_callbacks'
        include_stylesheet 'admin/maps'
        result << %{
<div id="mapviewer_#{asset.id}" class="mapviewer"></div>
  <script type="text/javascript">
  <!-- 
    //<![CDATA[
    function loadmap_#{asset.id}() {
        var mapviewer = new MultimapViewer( document.getElementById( 'mapviewer_#{asset.id}' ) );
        MM_setupRouteMap(mapviewer, '#{asset.thumbnail(:gpx)}');
    }
    MMAttachEvent( window, 'load', loadmap_#{asset.id} );
    //]]>
  // -->
</script>
        }
      elsif Radiant::Config['assets.gps.google_api_key']
        result << %{<p>Sorry. Google maps don't work yet.</p>}
      else
        result << %{<p>Map rendering requires either a Multimap (define setting <em>assets.gps.mm_api_key</em>) or (soon) a Google Maps API key (define setting <em>assets.gps.google_api_key</em>).</p>}
      end
    else
      result << %{<p>Asset <strong>#{asset.name}</strong> is not a GPS file</p>}
    end
    result
  end
  
end
