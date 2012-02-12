require 'spec_helper'

describe "LayoutLinks" do
  
  it "should have a Home page at '/' " do
    get '/'
    response.should have_selector('title', :content => "Acceuil")
  end
  
  it "should have a Aide page at '/aide' " do
    get '/aide'
    response.should have_selector('title', :content => 'Aide')
    response.should have_selector('p'    , :content => 'Aide')
  end
  
  it "should have a A Propos page at '/apropos' " do
    get '/apropos'
    response.should have_selector('title', :content => 'A Propos')
    response.should have_selector('p'    , :content => 'A Propos')
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => %(Inscription))
  end
  
  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => %(Connexion))
    end
  end # of when not signed in
  
  describe "when signed in" do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :session_email,    :with => @user.email
      fill_in :session_password, :with => @user.password
      click_button
    end
    
    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => %(Quitter))
    end
    
    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => %(Profil))
    end
    
  end # of when signed in
end
