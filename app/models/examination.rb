class Examination < ActiveRecord::Base
  attr_accessible :study, :name, :voltage, :current, :exposure
  
  validates :study, :presence => true,
                    :length   => { :maximum => 50 },
                    :format   => { :with => /\A[a-z\s\-]+\z/i }
end