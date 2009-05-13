module Paperclip
  # Translates uploaded routes into a few useful formats that we will either display or offer for download
  
  class RouteProcessor < Processor

    attr_accessor :current_format, :target_format, :whiny, :convert_options

    def initialize file, options = {}, attachment = nil
      raise PaperclipError, "!  Skipping non-gps thumbnail rule #{options[:geometry]}, #{options[:format]}" if options[:gpsbabel].nil?
      STDERR.puts ">   Obeying thumbnail rule #{options[:format]}"
      
      super
      @file             = file
      STDERR.puts "   file is #{@file}"
      
      
      @output_format    = options[:format]
      @gpsbabel_format  = options[:gpsbabel_format] || options[:format]
      input_ext         = File.extname(attachment.original_filename)
      STDERR.puts "   input_ext is #{input_ext}"
      @input_format     = input_ext == '.tcx' ? 'gtrnctr' : input_ext.gsub!(/^\./, '')
      STDERR.puts "   input_format is #{@input_format}"
      @basename         = File.basename(@file.path, input_ext)
      @filters          = options[:gpsbabel]
      @whiny            = options[:whiny].nil? ? true : options[:whiny]
    end
    
    # Returns true if the file is meant to make use of additional convert options.
    def filters?
      not @filters.blank?
    end

    # Performs the conversion of the +file+ into a different xml format. 
    # Returns the Tempfile that contains the new xml.
    def make
      
      return @file if @output_format == @input_format
      
      src = @file
      dst = Tempfile.new([@basename, @output_ext].compact.join("."))

      # build gpsbabel option string
      opt = %{ -i #{@input_format} }
      opt << %{ -f "#{ File.expand_path(src.path) }" }
      opt << @filters
      opt << %{ -o #{@gpsbabel_format} -F "#{ File.expand_path(dst.path) }" }
      
      STDERR.puts %{<<< gpsbabel #{opt.gsub(/\s+/, " ")}}
      
      begin
        success = Paperclip.run("gpsbabel", opt.gsub(/\s+/, " "))
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the route file #{@basename}" if @whiny
      end

      dst
    end

  end
end
