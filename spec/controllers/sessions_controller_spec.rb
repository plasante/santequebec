require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector(:title, :content => %(Connexion))
    end
  end # of describe GET new
  
  describe "POST :create" do
    describe "invalid signin" do
      before(:each) do
        @attr = {:email => "email@email.com", :password => "invalid"}
      end
      
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector('title', :content => %(Connexion Invalide))
      end
      
      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalide/i
      end
    end # of invalid signin
    
    describe "with valid email and password" do
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      it "should sign the user in"
      it "should redirect to the user show page"
    end # of valid signin
  end # of POST :create

end
