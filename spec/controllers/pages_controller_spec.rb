require 'spec_helper'

describe PagesController do
  render_views
  
  #TODO: testing todo
  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => "Sante Quebec" )
    end
    it "should contain Menu Principal" do
      get 'home'
      response.should have_selector("p", :content => "Menu Principal")
    end
  end

end
