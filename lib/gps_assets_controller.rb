module GpsAssetsController
  
  def self.included(base)
    base.class_eval do
      before_filter :fix_mime_type, :only => [:create, :update]
    end
  end
  
protected

  def fix_mime_type
    upload = params[:asset][:asset]
    if upload && upload.content_type == 'application/octet-stream'
      ext = File.extname(upload.original_filename)
      ext.slice!(0)                                                                       # to remove leading .
      params[:asset][:asset].content_type = Mime::Type.lookup_by_extension(ext).to_s      # note this only works with registered mime types
    end
  end
end

