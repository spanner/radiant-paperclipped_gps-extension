# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PaperclippedGpsExtension < Radiant::Extension
  version "1.0"
  description "Adds to paperclipped the ability to handle and display gps tracks in various formats. Requires gpsbabel."
  url "http://spanner.org/radiant/paperclipped_gps"
  
  extension_config do |config|
    config.gem 'paperclip'
    config.extension 'paperclipped'
    config.after_initialize do
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular 'gps', 'gpses'
      end
    end
  end
  
  def activate
    Mime::Type.register "application/gpx+xml", :gpx unless defined? Mime::GPX
    Mime::Type.register "application/tcx+xml", :tcx unless defined? Mime::TCX
    Mime::Type.register "application/vnd.google-earth.kml+xml", :kml unless defined? Mime::KML
    
    AssetType.new :gps, :mime_types => %w[application/gpx+xml application/tcx+xml application/vnd.google-earth.kml+xml], :processors => [:gps_processor], :styles => {
      :gpx => {:format => 'gpx', :gpsbabel => ''},
      :garmin => {:format => 'tcx', :gpsbabel_format => 'gtrnctr', :gpsbabel => "-r -x simplify,count=100 -x transform,rte=trk"},
      :google => {:format => 'kml', :gpsbabel => ''}
    }
    
    Paperclip::GpsProcessor
    Admin::AssetsController.send :include, GpsAssetsController
    Admin::AssetsController.send :helper, :gps
    Page.send :include, GpsTags

    # this adds a special case for javascript includes that omits the .js suffix for addresses starting with http
    # so that we can pull in multimap js from partials
    ActionView::Helpers::AssetTagHelper.send :include, AssetTagHelperModifications
  end
  
  def deactivate
  end
  
end


