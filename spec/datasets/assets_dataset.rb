class AssetsDataset < Dataset::Base
  uses :asset_sites if defined? Site
  
  def load
    create_asset :jpg
    create_asset :pdf, :asset_file_name => 'test.pdf', :asset_content_type => 'application/pdf', :asset_file_size => '54888'
    create_asset :gpx, :asset_file_name => 'test.gpx', :asset_content_type => 'application/gpx+xml', :asset_file_size => '110853'
    create_asset :tcx, :asset_file_name => 'test.tcx', :asset_content_type => 'application/tcx+xml', :asset_file_size => '494215'
    create_asset :mmo, :asset_file_name => 'test.mmo', :asset_content_type => 'text/xml', :asset_file_size => '24209'
  end
  
  helpers do
    def create_asset(title, attributes={})
      attributes = asset_attributes(attributes.update(:title => title))
      asset = create_model Asset, title.symbolize, attributes
    end
    
    def asset_attributes(attributes={})
      title = attributes[:title] || "Asset"
      symbol = title.symbolize
      attributes = { 
        :title => title,
        :asset_file_name =>  'test.jpg',
        :asset_content_type =>  'image/jpeg',
        :asset_file_size => '22167'
      }.merge(attributes)
      attributes[:site] = sites(:test) if defined? Site
      attributes
    end
  end
end
