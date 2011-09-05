require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET :index" do
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /Connectez pour acceder cette page./
      end
    end
    
    describe "for signed-in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :first_name => "Bob", :email => "email1@email.com")
        third = Factory(:user, :first_name => "Ben", :email => "email2@email.com")
        @users = [@user, second, third]
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Tous les usagers")
      end
      
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content => user.first_name + ' ' + user.last_name)
        end
      end
    end
  end # of describe GET :index
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Inscription")
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.first_name )
    end
    
    it "should include the user name" do
      get :show, :id => @user
      response.should have_selector(:title, :content => @user.first_name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      #response.should have_selector("h1>img", :class => "gravatar")
    end
  end
  
  describe "POST :create" do
    describe "failure" do
      before(:each) do
        @attr = { :first_name=>'', :last_name=>'', :email=>'', :password=>'', :password_confirmation=>'' }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector( :title , :content => %(Inscription) )
      end
      
      it "should render the :new page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
    end # of describe failure
    
    describe "success" do
      before(:each) do
        @attr = {:first_name=>'Pierre', 
                 :last_name=>'Lasante', 
                 :email=>'plasante@email.com', 
                 :password=>'123456',
                 :password_confirmation=>'123456'}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Bienvenue/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end # of describe success
    
  end # of "describe POST :create"
  
  describe "GET :edit" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => %(Modifier))
    end
  end # of describe GET :edit
  
  describe "PUT :update" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @attr = {:first_name => '',
                 :last_name  => '',
                 :email      => '',
                 :password   => '',
                 :password_confirmation => ''}
      end
      it "should render the :edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => %(Modifier))
      end
    end # of describe failure
     
    describe "success" do
      before(:each) do
        @attr = {:first_name => 'Pierrot',
                 :last_name  => 'Lasante',
                 :email      => 'pierrot@email.com',
                 :password   => '654321',
                 :password_confirmation => '654321'}
      end
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should == @attr[:first_name]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /Modif/i
      end
      
    end # of describe success
    
  end # of describe PUT :update
  
  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to :edit" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to :update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end # of describe for non-signed-in users
    
    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for :edit" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for :update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
      
    end # of describe for signed-in users
  end # of describe authentication
end
