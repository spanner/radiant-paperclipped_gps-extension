# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PaperclippedRoutesExtension < Radiant::Extension
  version "1.0"
  description "Adds to paperclipped the ability to handle and display gps tracks in various formats"
  url "http://spanner.org/radiant/paperclipped_routes"
  
  def activate
    Paperclip::RouteProcessor
    Asset.send :include, RouteAsset
    AssetsHelper.send :include, RouteHelper
  end
  
  def deactivate
  end
  
end
