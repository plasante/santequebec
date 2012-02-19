require 'spec_helper'
require 'faker'

describe ExaminationsController do
  render_views
  
  describe "GET :index" do
    describe "when not signed-in" do
      it "should deny access" do
        get :index
        response.should redirect_to signin_path
        controller.should_not be_signed_in
        flash[:notice].should =~ /connectez/i
      end
    end
    
    describe "when signed-in" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        33.times do
          Factory(:examination, :name => Faker::Name.name)
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All Examinations")
      end
      
      it "should have an element for each examination" do
        get :index
        Examination.paginate(:page => 1).each do |examination|
          response.should have_selector('li', :content => examination.name)
        end
      end
      
      it "should paginate examinations" do
        get :index
        response.should have_selector('div.pagination')
      end
      
      it "should have delete links for admins" do
        @user.toggle!(:admin)
        examination = Examination.first
        get :index
        response.should have_selector('a', :href => examination_path(examination),
                                           :content => "delete")
      end
      
      it "should not have delete links for non-admins" do
        examination = Examination.first
        get :index
        response.should_not have_selector('a', :href => examination_path(examination),
                                               :content => "delete")
      end
    end
  end # of describe GET :index
end
