module Paperclip
  # Translates uploaded tracks into a few useful formats that we will either display or offer for download
  
  class GpsProcessor < Processor

    attr_accessor :current_format, :target_format, :whiny, :convert_options

    def initialize file, options = {}, attachment = nil
      super
      @file             = file
      @output_format    = options[:format]
      @gpsbabel_format  = options[:gpsbabel_format] || options[:format]
      input_ext         = File.extname(attachment.original_filename)
      @input_format     = input_ext == '.tcx' ? 'gtrnctr' : input_ext.gsub!(/^\./, '')
      @basename         = File.basename(@file.path, input_ext)
      @filters          = options[:gpsbabel]
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
    end
    
    # Performs the conversion of the +file+ into a different xml format. 
    # Returns the Tempfile that contains the new xml.
    
    def make
      src = @file
      dst = Tempfile.new([@basename, @output_ext].compact.join("."))

      # build gpsbabel option string
      opt = %{ -i #{@input_format} }
      opt << %{ -f "#{ File.expand_path(src.path) }" }
      opt << @filters
      opt << %{ -o #{@gpsbabel_format} -F "#{ File.expand_path(dst.path) }" }
      
      begin
        success = Paperclip.run("gpsbabel", opt.gsub(/\s+/, " "))
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the GPS file #{@basename}" if @whiny
      end

      dst
    end

  end
end
