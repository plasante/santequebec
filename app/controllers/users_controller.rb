class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
    
  def index
    @title = %(Tous les usagers)
    @users = User.paginate(:page => params[:page])
  end
  
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
  
  def edit
    # We can now omit @user here since it is defined in the correct_user before_filter
    #@user = User.find(params[:id])
    @title = %(Modifier)
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = %(Modifier)
      redirect_to @user
    else
      @title = %(Modifier)
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = %(Utilisateur supprimer)
    redirect_to users_path
  end
    
  private
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
