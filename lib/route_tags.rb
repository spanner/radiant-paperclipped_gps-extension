module RouteTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

    desc %{
      Renders a flash-based media player suitable to the current asset file. This works for audio and video but currently is only tested with .flv and .mp3 files. An error will appear if the asset is not audio or video.

      With video, you can specify a pre-roll image with the parameter image="asset id". If none is specified then we'll use the first image attached to the same page.

      Other parameters you can pass through to the player:

      * width (in pixels. default is 400)
      * height (in pixels. default is 27 for audio, 327 for video. 27px is the height of the controls)
      * frontcolor (default is #4d4e53. aka Cool Grey 11)
      * backcolor (default is white)
      * allowFullScreen (whether permitted. default is true for video, false for audio)
      * autoplay (default is false)
      * version (flash player version required. default is 9)

      And make sure your layout brings in javascripts/swfobject.js.

      The flash file is the 'MPW player' by GrupoSistemas. See http://sourceforge.net/projects/mpwplayer.

    }    
    tag 'assets:map' do |tag|
      options = tag.attr.dup
      asset = find_asset(tag, options)
      if asset.route?
        url = asset.thumbnail(:gpx)
        width = options['width'] || 400
        height = options['height'] || 300

        result = %{
<div id="mapviewer_#{asset.id}" style="width: #{width}px; height: #{height}px;"></div>
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
      else
        raise TagError, "Asset is not a route."
      end
    end

end
