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

require 'spec_helper'

describe User do
  
  # The code inside the block is run before each example
  before(:each) do
    @attr = { :first_name => 'Pierre', :last_name => 'Lasante', :email => 'plasante@email.com' }
  end
  
  # This first example is a sanity check to verify the User model is working.
  it "should create a user given valid attributes" do
    User.create!(@attr)
  end
  
  # This is a spending spec, a way to describe behaviour without worrying yet about the implementation.
  it "should require a first_name" do
    no_first_name_user = User.new(@attr.merge(:first_name => ''))
    no_first_name_user.should_not be_valid
  end
  
  it "should require a last_name" do
    no_last_name_user = User.new(@attr.merge(:last_name => ''))
    no_last_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end
  
  it "should reject first_name that are too long" do
    long_first_name = "a" * 51
    long_first_name_user = User.new(@attr.merge(:first_name => long_first_name))
    long_first_name_user.should_not be_valid
  end
  
  it "should reject last_name that are too long" do
    long_last_name = "a" * 51
    long_last_name_user = User.new(@attr.merge(:last_name => long_last_name))
    long_last_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@fooljp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
end
