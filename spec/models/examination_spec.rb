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
  
  it "should require a study" do
    no_study_examination = Examination.new(@attr.merge(:study => ""))
    no_study_examination.should_not be_valid
  end
  
  it "should reject study that are too long" do
    long_study = "a" * 51
    long_study_examination = Examination.new(@attr.merge(:study => long_study))
    long_study_examination.should_not be_valid
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
end