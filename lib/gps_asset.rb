module GpsAsset

  def self.included(base)
    
    base.class_eval {
      register_type :gps, %w[application/gpx+xml application/tcx+xml]

      extend ClassMethods
      include InstanceMethods
      
      alias_method_chain :choose_processors, :gps
      alias_method_chain :thumbnail, :gps
      alias download thumbnail    # initially just for readability, but soon we will be able to create image thumbnails of tracks
    }

    class << base
      alias_method_chain :thumbnail_definitions, :gps
    end

  end

  module ClassMethods     
    def thumbnail_definitions_with_gps   # NB. gps processor will ignore thumbnail rules without a :gpsbabel parameter
      thumbnail_definitions_without_gps.merge(gps_translations)
    end
    
    def gps_translations
      {
        :gpx => {:format => 'gpx', :gpsbabel => ''},
        :garmin => {:format => 'tcx', :gpsbabel_format => 'gtrnctr', :gpsbabel => "-r -x simplify,count=100 -x transform,rte=trk"},
        :google => {:format => 'kml', :gpsbabel => ''},
      }
    end
  end
  
  module InstanceMethods
    
    def choose_processors_with_gps
      self.gps? ? [:gps_processor] : choose_processors_without_gps
    end
    
    def thumbnail_with_gps(format='gpx')
      if self.gps? 
        if self.class.gps_translations.keys.include?(format.to_sym)
          self.asset.url(format.to_sym)
        elsif format == 'thumbnail'
          "/images/assets/track_thumbnail.png"
        else
          "/images/assets/track_icon.png"
        end
      else
        thumbnail_without_gps(format)
      end
    end

  end
end


