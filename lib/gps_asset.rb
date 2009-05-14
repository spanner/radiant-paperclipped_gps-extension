module GpsAsset

  def self.included(base)
    
    base.extend ClassMethods
    base.class_eval {
      include InstanceMethods
      @@gps_content_types = ['application/gpx+xml', 'application/tcx+xml']
      @@gps_extensions = ['.gpx', '.kml', '.tcx']
      @@gps_translations = {
        :gpx => {:format => 'gpx', :trackbabel => ''},
        :garmin => {:format => 'tcx', :trackbabel_format => 'gtrnctr', :trackbabel => "-r -x simplify,count=100 -x transform,rte=trk"},
        :google_earth => {:format => 'kml', :trackbabel => ''},
        :memory_map => {:format => 'mmo', :trackbabel => ''},
      }
      cattr_reader :gps_content_types, :gps_extensions, :gps_translations
      
      @@track_condition = send(:sanitize_sql, ['asset_content_type LIKE ? OR asset_content_type LIKE ?', *gps_content_types]).freeze
      cattr_reader :track_condition
      named_scope :tracks, :conditions => self.track_condition    #gps doesn't pluralize well
      content_categories.push :track  # and this has to match the condition

      # overridden to make 'other' exclude tracks too
      # really this would be chainable, but it works for now
      self.other_condition = send(:sanitize_sql, [
        'asset_content_type NOT LIKE ? AND asset_content_type NOT LIKE ? AND asset_content_type NOT IN (?)',
        'audio%', 'video%', (extra_content_types[:movie] + extra_content_types[:audio] + image_content_types + gps_content_types)]).freeze

      # aliased instance methods
      alias_method_chain :choose_processors, :gps
      alias_method_chain :set_content_type, :gps
    }

      
    class << base
      def track?(asset_content_type)
        asset_content_type.to_s == 'application/gpx+xml' || asset_content_type.to_s == 'application/tcx+xml'
      end
      alias gps? track?  

      # aliased class methods
      alias_method_chain :thumbnail_definitions, :gps
    end

  end

  module ClassMethods     
    def thumbnail_definitions_with_gps   # NB. gps processor will ignore thumbnail rules without a :trackbabel parameter
      thumbnail_definitions_without_gps.merge(gps_translations)
    end
  end
  
  module InstanceMethods     
    
    # track files are just xml and don't seem to have proper mime-types, so we normally have to use the extension.
    def track?
      self.class.gps_extensions.include?(File.extname(self.asset.instance_read(:file_name))) || self.class.send(:track?, self.asset_content_type)
    end
    alias gps? track?  
    
    def choose_processors_with_gps
      processors = self.track? ? [:gps_processor] : choose_processors_without_gps
    end

    def set_content_type_with_gps
      if File.extname(asset_file_name) == '.gpx' 
        asset.instance_write :content_type, "application/gpx+xml"
      elsif File.extname(asset_file_name) == '.tcx' 
        asset.instance_write :content_type, "application/tcx+xml"
      else
        set_content_type_without_gps
      end
    end

  end
end


