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
      response.should have_selector("title", :content => "Santé" )
    end
    it "should have the right entete" do
      get 'home'
      response.should have_selector("h1", :content => "Santé")
    end
  end

end
