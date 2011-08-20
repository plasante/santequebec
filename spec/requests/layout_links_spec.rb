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
end
