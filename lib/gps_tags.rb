module GpsTags
  include Radiant::Taggable
  
  class TagError < StandardError; end

    desc %{
      Renders a multimap slidy-map viewer of the specified asset, provided it's a gps track.
      So far only takes height and width parameters.

      Your layout must include the main multimap js call and another javascript file that picks up the mapviewer div and sets up the right callbacks.
      
      See the included javascripts/platform/multimap.js for an example.
      
      Usage:
      <pre><code><r:assets:multimap id="1" width="400" height="300" /></code></pre>
    }    
    tag 'assets:multimap' do |tag|
      options = tag.attr.dup
      tag.locals.asset = find_asset(tag, options)
      if tag.locals.asset.gps?
        url = tag.locals.asset.thumbnail(:gpx)
        width = options['width'] || "100%"
        height = options['height'] || "400px"
        result = %{
          <div id="mapviewer_#{tag.locals.asset.id}" class="mapviewer" style="width: #{width}; height: #{height};">
            <a class="route" href="#{url}">#{tag.locals.asset.title}</a>
          </div>
        }
      else
        raise TagError, "Asset is not a GPS file."
      end
    end

    desc %{
      Returns the address of the asset with the specified format. This is really an alias for r:assets:url but with alternative parameter names that make more sense for non-image files.
      For GPS files the format options include 'gpx', 'google' and 'garmin'.
      Thumbnail names also work.

      *Usage:* 
      <pre><code><r:assets:download [title="asset_title"] [format="gpx"]></code></pre>
    }
    tag 'assets:download' do |tag|
      tag.attr['size'] = tag.attr['format']
      tag.render('assets:url')
    end

    desc %{
      Returns a link to the asset with the specified format. This is really an alias for r:assets:link but with alternative parameter names that make more sense for non-image files.
      For GPS files the format options include 'gpx', 'google' (for kml) and 'garmin' (for tcx).
      Thumbnail names also work.

      *Usage:* 
      <pre><code><r:assets:download_link [title="asset_title"] [format="gpx"]>Linking text</r:assets:download_link></code></pre>
    }
    tag 'assets:download_link' do |tag|
      tag.attr['size'] = tag.attr['format']
      tag.render('assets:link')
    end

end
