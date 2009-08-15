require File.dirname(__FILE__) + '/../spec_helper'

describe Asset do
  dataset :assets
  
  it "should include GpsAsset" do
    Asset.included_modules.include?(GpsAsset).should be_true
  end
  
  it "should know about GPS assets" do
    Asset.known_types.include?(:gps).should be_true
  end
  
  it "should know about GPS mime types" do
    Mime::GPS.should_not be_nil
    Asset.gps?('application/tcx+xml').should be_true
    Asset.gps?('application/gpx+xml').should be_true
  end
  
  describe "GPS processing rules" do
    it "should have been defined" do
      Asset.thumbnail_definitions.include?(:gpx).should be_true
      Asset.thumbnail_definitions.include?(:garmin).should be_true
      Asset.thumbnail_definitions.include?(:google).should be_true
    end
    
    it "should all have a :gpsbabel key" do
      Asset.thumbnail_definitions[:gpx][:gpsbabel].should_not be_nil
      Asset.thumbnail_definitions[:garmin][:gpsbabel].should_not be_nil
      Asset.thumbnail_definitions[:google][:gpsbabel].should_not be_nil
    end
  end
  
  describe "an image asset" do
    it "should still declare itself image" do
      assets(:jpg).image?.should be_true
    end
    it "should not declare itself gps" do
      assets(:jpg).gps?.should_not be_true
    end
    it "should choose the thumbnail processor" do
      assets(:jpg).choose_processors.include?(:gps_processor).should be_false
      assets(:jpg).choose_processors.include?(:thumbnail).should be_true
    end
  end

  describe "a gps asset" do
    it "should declare itself gps" do
      assets(:gpx).gps?.should be_true
    end
    
    it "should choose the gps processor" do
      assets(:gpx).choose_processors.include?(:gps_processor).should be_true
      assets(:gpx).choose_processors.include?(:thumbnail).should be_false
    end
  end

end
