# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor   :password
  
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+[a-z]+\z/i
  
  validates(:first_name, :presence     => true,
                         :length       => {:maximum => 50})
  validates(:last_name,  :presence     => true,
                         :length       => {:maximum => 50})
  validates(:email,      :presence     => true,
                         :format       => {:with => email_regex},
                         :uniqueness   => {:case_sensitive => false})
  validates(:password,   :presence     => true,
                         :confirmation => true,
                         :length       => {:within => 6..40})
  before_save :encrypt_password
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    #Compare encrypted password with the encrypted version of submitted_password.
    encrypted_password == encrypt(submitted_password)
  end
  
  #
  # The third case (password mismatch) is implicitly implemented. If we reach
  # the end of the method then it automatically returns nil.
  #
  def self.authenticate(submitted_email_str, submitted_password_str)
    user = find_by_email(submitted_email_str)
    return nil if user.nil?
    return user if user.has_password?(submitted_password_str)
  end
  
  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
