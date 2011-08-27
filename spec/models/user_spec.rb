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
    @attr = { :first_name            => 'Pierre', 
              :last_name             => 'Lasante', 
              :email                 => 'plasante@email.com',
              :password              => '179317',
              :password_confirmation => '179317'}
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
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end
  
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => 'invalid')).should_not be_valid
    end
  
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
  
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
    
    it "should not reject passwords length between 6..40" do
      correct = "a" * 10
      hash = @attr.merge(:password => correct, :password_confirmation => correct)
      User.new(hash).should be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    # The has_password method is the public interface to the encryption machinery.
    describe "has_password? method" do
      it "should be true of the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords dont match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
        it "should return nil on email/password mismatch" do
            wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
            wrong_password_user.should be_nil
        end
        it "should return nil on email address with not user" do
            nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
            nonexistent_user.should be_nil
        end
        it "should return the user on email/password match" do
            matching_user = User.authenticate(@attr[:email], @attr[:password])
            matching_user.should == @user
        end
    end
  end
end
