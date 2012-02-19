require 'spec_helper'

describe Examination do
  before(:each) do
    @attr = { :study => "KNEE",
              :name  => "Anonymized",
              :voltage => "120",
              :current => "10",
              :exposure => "1"}
  end
  
  it "should create a new examination given valid attributes" do
    Examination.create!(@attr)
  end
  
  describe "study validation" do
    it "should require a study" do
      no_study_examination = Examination.new(@attr.merge(:study => ""))
      no_study_examination.should_not be_valid
    end
    
    it "should reject study that are too long" do
      long_study = "a" * 51
      long_study_examination = Examination.new(@attr.merge(:study => long_study))
      long_study_examination.should_not be_valid
    end
    
    it "should reject study that are too short" do
      short_study = "a" * 3
      short_study_examination = Examination.new(@attr.merge(:study => short_study))
      short_study_examination.should_not be_valid
    end
    
    it "should accept valid study" do
      studies = ["Left Knee","Knee","Helax-TMS generated study"]
      studies.each do |study|
        valid_study = Examination.new(@attr.merge(:study => study))
        valid_study.should be_valid
      end
    end
    
    it "should reject invalid study" do
      studies = ["Left!Knee","+Knee"]
      studies.each do |study|
        invalid_study = Examination.new(@attr.merge(:study => study))
        invalid_study.should_not be_valid
      end
    end
  end # of describe study validation
  
  describe "name validation" do
    it "should require a name" do
      no_name_examination = Examination.new(@attr.merge(:name => ""))
      no_name_examination.should_not be_valid
    end
    
    it "should reject name that are too long" do
      long_name = "a" * 51
      long_name_examination = Examination.new(@attr.merge(:name => long_name))
      long_name_examination.should_not be_valid
    end
    
    it "should reject name that are too short" do
      short_name = "a" * 3
      short_name_examination = Examination.new(@attr.merge(:name => short_name))
      short_name_examination.should_not be_valid
    end
    
    it "should accept valid name" do
      valid_names = ["Pierre Lasante", "Mary O'Connor"]
      valid_names.each do |name|
        Examination.new(@attr.merge(:name => name)).should be_valid
      end
    end
    
    it "should reject invalid name" do
      invalid_names = ["Pierr! Lasante", "Karo @penard"]
      invalid_names.each do |name|
        Examination.new(@attr.merge(:name => name)).should_not be_valid
      end
    end
  end # of describe name validation 
  
  describe "voltage validation" do
    it "should accept nil voltage value" do
      nil_voltage = nil
      nil_voltage_examination = Examination.new(@attr.merge(:voltage => nil_voltage))
      nil_voltage_examination.should be_valid
    end
    
    it "should reject voltage that are too low" do
      low_voltage = 0
      low_voltage_examination = Examination.new(@attr.merge(:voltage => low_voltage.to_s))
      low_voltage_examination.should_not be_valid
    end
    
    it "should reject voltage that are too high" do
      high_voltage = 1001
      high_voltage_examination = Examination.new(@attr.merge(:voltage => high_voltage.to_s))
      high_voltage_examination.should_not be_valid
    end
  end # of describe voltage validation
  
  describe "current validation" do
    it "should accept nil current value" do
      nil_current = nil
      nil_current_examination = Examination.new(@attr.merge(:current => nil_current))
      nil_current_examination.should be_valid
    end
    
    it "should reject current that are too low" do
      low_current = 0
      low_current_examination = Examination.new(@attr.merge(:current => low_current.to_s))
      low_current_examination.should_not be_valid
    end
    
    it "should reject current that are too high" do
      high_current = 1001
      high_current_examination = Examination.new(@attr.merge(:current => high_current.to_s))
      high_current_examination.should_not be_valid
    end
  end # of describe current validation
  
  describe "exposure validation" do
    it "should accept nil exposure value" do
      nil_exposure = nil
      nil_exposure_examination = Examination.new(@attr.merge(:exposure => nil_exposure))
      nil_exposure_examination.should be_valid
    end
    
    it "should reject exposure that are too low" do
      low_exposure = 0
      low_exposure_examination = Examination.new(@attr.merge(:exposure => low_exposure.to_s))
      low_exposure_examination.should_not be_valid
    end
    
    it "should reject exposure that are too high" do
      high_exposure = 1001
      high_exposure_examination = Examination.new(@attr.merge(:exposure => high_exposure.to_s))
      high_exposure_examination.should_not be_valid
    end
  end # of describe exposure validation
end