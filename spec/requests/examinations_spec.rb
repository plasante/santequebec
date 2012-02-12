require 'spec_helper'

describe "Examinations" do
  describe "GET /examinations" do
    describe "for non signed-in users" do
      it "should protect the page" do
        visit examinations_path
        response.should render_template("sessions/new")
        flash[:notice].should =~ /connectez/i
        controller.should_not be_signed_in
      end
    end # of for non signed-in users
    
    describe "for signed-in users" do
      it "should render examinations/index" do
        @user = Factory(:user)
        visit signin_path
        fill_in :session_email, :with => @user.email
        fill_in :session_password, :with => @user.password
        click_button
        controller.should be_signed_in
        visit examinations_path
        response.should render_template("examinations/index")
        response.should have_selector("title", :content => %(Examinations))
      end
    end # of for signed-in users
  end
end
