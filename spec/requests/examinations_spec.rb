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
  end # of describe GET /examinations
  
  describe "stale object" do
    it "should detect stale object" do
      user1 = login(:user1)
      user2 = login(:user2)
      
      examination = Factory(:examination)
      
      user1.controller.should be_signed_in
      user2.controller.should be_signed_in
      
      user1.visit edit_examination_path( examination )
      user2.visit edit_examination_path( examination )
      
      user1.fill_in :examination_study, :with => %(Shoulder)
      user1.click_button
      
      user2.fill_in :examination_study, :with => %(another study)
      user2.click_button
      user2.flash[:error].should =~ /Examination has been changed by someone else/i
    end
    
  private
  
    module CustomDs1
      
    end
    
    def login(user)
      open_session do |session|
        session.extend(CustomDs1)
        u = Factory(:user, :email => Factory.next(:email), :admin => true)
        session.visit signin_path
        session.fill_in :session_email, :with => u.email
        session.fill_in :session_password, :with => u.password
        session.click_button
      end
    end
  end
end
