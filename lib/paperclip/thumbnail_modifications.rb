module Paperclip
  module ThumbnailModifications

    def self.included(base)
      unless base.instance_methods.include?('initialize_with_gps')
        base.class_eval {
          def initialize_with_gps file, options = {}, attachment = nil
            raise PaperclipError, "Skipping non-image thumbnail rule #{options[:format]}" if options[:geometry].nil?
            initialize_without_gps(file, options, attachment)
          end
          alias_method_chain :initialize, :gps
        }
      end
    end
  end
end
