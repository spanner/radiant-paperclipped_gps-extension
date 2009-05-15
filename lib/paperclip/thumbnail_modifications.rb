module Paperclip
  module ThumbnailModifications

    def self.included(base)
      base.class_eval {

        def initialize_with_gps file, options = {}, attachment = nil
          raise PaperclipError, "Skipping non-image thumbnail rule #{options[:format]}" if options[:geometry].nil?
          initialize_without_gps(file, options, attachment)
        end
        alias_method_chain :initialize, :gps

        def make_with_gps
          # call multimap for geometry rules if this is a map file

          make_without_gps
        end
        alias_method_chain :make, :gps

      }
    end

  end
end