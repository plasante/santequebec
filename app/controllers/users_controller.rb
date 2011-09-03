class UsersController < ApplicationController
  def new
    @title = %(Inscription)
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.first_name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = %(Bienvenue)
      redirect_to @user
    else
      @title = %(Inscription)
      render :new
    end
  end
end
