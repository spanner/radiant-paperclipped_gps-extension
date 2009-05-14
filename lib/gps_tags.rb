module GpsTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

    desc %{
      Renders a multimap slidy-map viewer of the specified asset, provided it's a gps track.
      So far only takes height and width parameters.

      Your layout must include the main multimap js call and another javascript file that defines the MM_setupRouteMap and MM_showRouteMap callbacks. 
      See the included javascripts/mm_gps.js for an example.
      
      Usage:
      <pre><code><r:assets:multimap id="1" width="400" height="300" /></code></pre>
    }    
    tag 'assets:multimap' do |tag|
      options = tag.attr.dup
      asset = find_asset(tag, options)
      if asset.track?
        url = asset.thumbnail(:gpx)
        width = options['width'] || 400
        height = options['height'] || 300

        result = %{
<div id="mapviewer_#{asset.id}" class="mapviewer" style="width: #{width}px; height: #{height}px;"></div>
<script type="text/javascript">
  <!-- 
  //<![CDATA[
  function loadmap_#{asset.id}() {
      var mapviewer = new MultimapViewer( document.getElementById( 'mapviewer_#{asset.id}' ) );
      mapviewer.addWidget(new MMSmallPanZoomWidget());
      mapviewer.setAllowedZoomFactors(13, 15);
      MM_setupRouteMap(mapviewer);
      MM_showRouteMap(mapviewer, '#{asset.thumbnail(:gpx)}');
  }
  MMAttachEvent( window, 'load', loadmap_#{asset.id} );
  //]]>
  // -->
</script>
        }
      else
        raise TagError, "Asset is not a GPS file."
      end
    end

    desc %{
      Returns the address of the asset with the specified format. This is really an alias for r:assets:thumbnail but with alternative parameter names that make more sense for non-image files.
      For GPS files the format options include 'gpx', 'google', 'garmin' and 'mmap'. 
      Thumbnail names also work.

      *Usage:* 
      <pre><code><r:assets:download [title="asset_title"] [format="gpx"]></code></pre>
    }
    tag 'assets:download' do |tag|
      tag.attr['size'] = tag.attr.delete('format')
      tag.render('assets:thumbnail')
    end

end
