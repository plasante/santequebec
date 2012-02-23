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
  
  describe "GET :show" do
    before(:each) do
      @examination = Factory(:examination)
    end
    
    it "should be successful" do
      get :show, :id => @examination
      response.should be_success
    end
    
    it "should find the right examination" do
      get :show, :id => @examination
      assigns(:examination).should == @examination
    end
    
    it "should have the examination's name" do
      get :show, :id => @examination
      response.should have_selector('h1', :content => @examination.name)
    end
    
    describe "non-existent examination" do
      it "should redirect to the examinations page" do
        get :show, :id => 0
        response.should redirect_to examinations_path
      end
      
      it "should have a flash error message" do
        get :show, :id => 0
        flash[:error].should =~ /invalid/i
      end
    end
  end # of describe GET :show
  
  describe "authentication of edit/update actions" do
    before(:each) do
      @examination = Factory(:examination)
    end
    
    describe "for non signed-in users" do
      it "should deny access to edit" do
        get :edit, :id => @examination
        response.should redirect_to signin_path
        flash[:notice].should =~ /connectez/i
      end
      
      it "should deny access to update" do
        put :update, :id => @examination, :examination => {}
        response.should redirect_to signin_path
        flash[:notice].should =~ /connectez/i
      end
    end
    
    describe "for signed_in users" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      it "should require an admin user to edit" do
        get :edit, :id => @examination
        response.should redirect_to examinations_path
      end
      
      it "should require an admin user to update" do
        put :update, :id => @examination, :examination => {}
        response.should redirect_to examinations_path
      end
    end
  end # of authentication of edit/update actions
  
  describe "GET :edit" do
    before(:each) do
      test_sign_in(Factory(:user, :admin => true))
      @examination = Factory(:examination)
    end
    
    it "should be successful" do
      get :edit, :id => @examination
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @examination
      response.should have_selector("title", :content => %(Edit Examination))
    end
    
    it "should edit the right examination" do
      get :edit, :id => @examination
      assigns(:examination).should == @examination
    end
    
    it "should have a flash message if examination not found" do
      get :edit, :id => 0
      flash[:error].should =~ /not found/i
      response.should redirect_to examinations_path
    end
  end # of describe GET :edit
  
  describe "PUT :update" do
    before(:each) do
      @admin = Factory(:user, :admin => true)
      @examination = Factory(:examination)
      test_sign_in(@admin)
    end
    
    describe "examination not found" do
      it "should have a flash message for examination not found" do
        put :update, :id => 0, :examination => {}
        flash[:error].should =~ /not found/i
        response.should redirect_to examinations_path
      end
    end
    
    describe "failure" do
      before(:each) do
        @attr = {:study => "", :name => "", :voltage => "", :current => "", :exposure => ""}
      end
      
      it "should re-render the edit page" do
        put :update, :id => @examination, :examination => @attr
        response.should render_template("edit")
      end
      
      it "should have the right title" do
        put :update, :id => @examination, :examination => @attr
        response.should have_selector("title", :content => %(Edit Examination))
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :study => "Shoulder", :name => "Pierre", :voltage => "1", :current => "2", :exposure => "3"}
      end
      
      it "should update the examination" do
        put :update, :id => @examination, :examination => @attr
        @examination.reload
        @examination.study.should == @attr[:study]
      end
      
      it "should have a flash message" do
        put :update, :id => @examination, :examination => @attr
        flash[:success].should =~ /Succesfully/i
      end
      
      it "should render the examination page" do
        put :update, :id => @examination, :examination => @attr
        response.should redirect_to examination_path(assigns(:examination))
      end
    end
  end # of describe PUT :update
  
  describe "authentication of edit/update actions" do
    before(:each) do
      @examination = Factory(:examination)
    end
    
    describe "for non signed-in users" do
      it "should deny access to edit actions" do
        get :edit, :id => @examination
        response.should redirect_to signin_path
        flash[:notice].should =~ /Connectez/i
      end
      
      it "should deny access to update action" do
        put :update, :id => @examination, :examination => {}
        response.should redirect_to signin_path
        flash[:notice].should =~ /Connectez/i
      end
    end
    
    describe "for signed_in users " do
      describe "for non admin users" do
        before(:each) do
          test_sign_in(Factory(:user))
        end
        
        it "should protect the edit actions" do
          get :edit, :id => @examination
          response.should redirect_to examinations_path
        end
        
        it "should protect the update actions" do
          put :update, :id => @examination, :examination => {}
          response.should redirect_to examinations_path
        end
      end
    end
  end # of describe authentication of edit/update actions
  
  describe "DELETE :destroy" do
    before(:each) do
      @examination = Factory(:examination)
    end
    
    describe "for non existent examination record" do
      it "should detect non existent examination record" do
        test_sign_in(Factory(:user))
        delete :destroy, :id => 0
        response.should redirect_to examinations_path
      end
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @examination
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as non-admin user" do
      it "should protect the action" do
        test_sign_in(Factory(:user))
        delete :destroy, :id => @examination
        response.should redirect_to( examinations_path )
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        @admin = Factory(:user, :admin => true)
        @examination = Factory(:examination)
        test_sign_in(@admin)
      end
      
      it "should destroy the examination" do
        lambda do
          delete :destroy, :id => @examination
        end.should change(Examination, :count).by(-1)
      end
      
      it "should redirect to the examinations page" do
        delete :destroy, :id => @examination
        flash[:success].should =~ /destroyed/i
        response.should redirect_to(examinations_path)
      end
    end
  end # of DELETE :destroy 
end
