class Examination < ActiveRecord::Base
  attr_accessible :study, :name, :voltage, :current, :exposure, :lock_version
  
  validates :study, :presence => true,
                    :length   => { :within => 4..50 },
                    :format   => { :with => /\A[a-z\s\-]+\z/i }
  
  validates :name, :presence => true,
                   :length => { :within => 4..50 },
                   :format => { :with => /\A[a-z\s\d\-.']+\z/i}
  
  validates :voltage, :numericality => { :greater_than => 0, :less_than_or_equal_to => 1000},
                      :allow_nil => true
  
  validates :current, :numericality => { :greater_than => 0, :less_than_or_equal_to => 1000},
                      :allow_nil => true
                      
  validates :exposure, :numericality => { :greater_than => 0, :less_than_or_equal_to => 1000},
                       :allow_nil => true
end