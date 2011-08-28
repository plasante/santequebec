# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  attr_accessor   :password
  
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # /          start of regex
  # \A         match start of a string
  # [\w+\-.]+  at least one word character,plus hyphen or dot
  # @          literal "at sign"
  # [a-z\d-.]+ at least one letter, digit, hyphen, or dot
  # \.         literal "dot"
  # [a-z]+     at least one letter
  # \z         match end of a strint
  # /          end of regex
  # i          case insensitive

  validates :first_name, :presence     => { :message => 'est obligatoire'},
                         :length       => { :maximum => 50 , :message => 'est trop long ( 50 max )'}
  validates :last_name,  :presence     => { :message => 'est obligatoire'},
                         :length       => { :maximum => 50 , :message => 'est trop long ( 50 max )'}
  validates :email,      :presence     => { :message => 'est obligatoire'},
                         :format       => { :with => email_regex, :message => 'a un format invalide.' },
                         :uniqueness   => { :case_sensitive => false, :message => 'est deja pris.'}
  
  # Automatically create the virtual attribute 'password_confirmation'
  validates :password,   :presence     => { :message => 'est obligatoire'},
                         :confirmation => { :message => 'est obligatoire'},
                         :length       => { :within => 6..40, :message => 'doit avoir entre 6 et 40 caracteres' }
  
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
