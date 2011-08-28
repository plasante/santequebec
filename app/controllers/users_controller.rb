class UsersController < ApplicationController
  def new
    @title = %(Inscription)
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.first_name
  end

end
