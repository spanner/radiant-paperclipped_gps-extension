# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PaperclippedGpsExtension < Radiant::Extension
  version "1.0"
  description "Adds to paperclipped the ability to handle and display gps tracks in various formats"
  url "http://spanner.org/radiant/paperclipped_gps"
  
  def activate
    Paperclip::GpsProcessor
    Asset.send :include, GpsAsset
    AssetsHelper.send :include, GpsHelper
    Page.send :include, GpsTags
    Paperclip::Thumbnail.send :include, Paperclip::ThumbnailModifications
  end
  
  def deactivate
  end
  
end
