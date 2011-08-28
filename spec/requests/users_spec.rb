require 'spec_helper'

describe "Users" do
  describe "Signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "user_first_name",            :with => ""
          fill_in "user_last_name",             :with => ""
          fill_in "user_email",                 :with => ""
          fill_in "user_password",              :with => ""
          fill_in "user_password_confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end # of describe failure
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "user_first_name",            :with => "Pierre"
          fill_in "user_last_name",             :with => "Lasante"
          fill_in "user_email",                 :with => "plasante@email.com"
          fill_in "user_password",              :with => "123456"
          fill_in "user_password_confirmation", :with => "123456"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.success", :content => %(Bienvenue))
        end.should change(User, :count).by(1)
      end
    end # of describe success
  end
end
