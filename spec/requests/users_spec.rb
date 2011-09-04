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
  end # of describe signup
  
  describe "signin/signout" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :session_email, :with => ''
        fill_in :session_password, :with => ''
        click_button
        response.should have_selector("div.flash.error", :content => %(Invalid))
      end
    end
    
    describe "success" do
      it "should sign a user in" do
        user = Factory(:user)
        visit signin_path
        fill_in :session_email, :with => user.email
        fill_in :session_password, :with => user.password
        click_button
        controller.should be_signed_in
        #click_link "Quitter"
        #controller.should_not be_signed_in
      end
    end
    
  end # of describe signin/signout
end
