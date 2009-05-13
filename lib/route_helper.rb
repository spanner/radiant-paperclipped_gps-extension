module RouteHelper

  def self.included(base)
    base.module_eval {
      
      def map_for(asset)
        if asset.route?
          result = %{
<div id="mapviewer_#{asset.id}" style="width: 600px; height: 400px;"></div>
          }
          result << %{
<script type="text/javascript">
  <!-- 
  //<![CDATA[
  function onLoad() {
      var mapviewer = new MultimapViewer( document.getElementById( 'mapviewer_#{asset.id}' ) );
      MMDataResolver.setDataPreferences(MM_WORLD_MAP, [904]);
      mapviewer.addWidget(new MMSmallPanZoomWidget());
      mapviewer.setAllowedZoomFactors(13, 15);
      var request = mapviewer.getXMLHTTPRequest();
      request.open( 'GET', '#{asset.thumbnail(:gpx)}', true );
      request.onreadystatechange = MM_showGPX(request, mapviewer);
      request.send(null);
  }
  MMAttachEvent( window, 'load', onLoad );
  //]]>
  // -->
</script>
          }

        end
      end

    }
  end
  
end
