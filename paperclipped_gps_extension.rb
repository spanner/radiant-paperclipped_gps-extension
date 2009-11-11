# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PaperclippedGpsExtension < Radiant::Extension
  version "1.0"
  description "Adds to paperclipped the ability to handle and display gps tracks in various formats"
  url "http://spanner.org/radiant/paperclipped_gps"
  
  def activate
    Mime::Type.register "application/gpx+xml", :gpx
    Mime::Type.register "application/tcx+xml", :tcx
    Mime::Type.register "application/vnd.google-earth.kml+xml", :kml
    
    # this adds a special case for javascript includes that omits the .js suffix if the address ends in /
    ActionView::Helpers::AssetTagHelper.send :include, AssetTagHelperModifications
    
    Paperclip::GpsProcessor
    Asset.send :include, GpsAsset
    Admin::AssetsController.send :include, GpsAssetsController
    Admin::AssetsController.send :helper, :gps
    Page.send :include, GpsTags
    Paperclip::Thumbnail.send :include, Paperclip::ThumbnailModifications
  end
  
  def deactivate
  end
  
end


