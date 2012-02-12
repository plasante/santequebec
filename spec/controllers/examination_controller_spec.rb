require 'spec_helper'

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
      
    end
  end
end
