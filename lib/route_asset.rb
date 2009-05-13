module RouteAsset

  def self.included(base)
    
    base.extend ClassMethods
    base.class_eval {
      include InstanceMethods
      @@route_content_types = ['application/gpx+xml', 'application/tcx+xml']
      @@route_extensions = ['.gpx', '.kml', '.tcx']
      cattr_reader :route_content_types, :route_extensions
      
      @@route_condition = send(:sanitize_sql, ['asset_content_type LIKE ? OR asset_content_type LIKE ?', *route_content_types]).freeze
      @@route_translations = {
        :gpx => {:format => 'gpx', :gpsbabel => ''},
        :garmin => {:format => 'tcx', :gpsbabel_format => 'gtrnctr', :gpsbabel => "-r -x simplify,count=100 -x transform,rte=trk"},
        :google_earth => {:format => 'kml', :gpsbabel => ''},
        :memory_map => {:format => 'mmo', :gpsbabel => ''},
      }
      cattr_reader :route_condition, :route_translations
      named_scope :routes, :conditions => self.route_condition
      content_categories.push :route

      # overridden to make 'other' exclude routes too
      # really this should be chainable, but it works for now
      self.other_condition = send(:sanitize_sql, [
        'asset_content_type NOT LIKE ? AND asset_content_type NOT LIKE ? AND asset_content_type NOT IN (?)',
        'audio%', 'video%', (extra_content_types[:movie] + extra_content_types[:audio] + image_content_types + route_content_types)]).freeze

      # aliased instance methods
      alias_method_chain :choose_processors, :routes
      alias_method_chain :set_content_type, :routes
    }

      
    class << base
      def route?(asset_content_type)
        asset_content_type.to_s == 'application/gpx+xml' || asset_content_type.to_s == 'application/tcx+xml'
      end        

      # aliased class methods
      alias_method_chain :thumbnail_definitions, :routes
    end

  end

  module ClassMethods     
    def thumbnail_definitions_with_routes   # NB. route processor will ignore thumbnail rules without a :gpsbabel parameter
      thumbnail_definitions_without_routes.merge(route_translations)
    end
  end
  
  module InstanceMethods     
    
    # gps files are just xml and don't seem to have proper mime-types, so we normally have to use the extension.
    def route?
      self.class.route_extensions.include?(File.extname(self.asset.instance_read(:file_name))) || self.class.send(:route?, self.asset_content_type)
    end
    
    def choose_processors_with_routes
      processors = self.route? ? [:route_processor] : choose_processors_without_routes
      processors
    end

    def set_content_type_with_routes
      if File.extname(asset_file_name) == '.gpx' 
        asset.instance_write :content_type, "application/gpx+xml"
      elsif File.extname(asset_file_name) == '.tcx' 
        asset.instance_write :content_type, "application/tcx+xml"
      else
        set_content_type_without_routes
      end
    end

  end
end


