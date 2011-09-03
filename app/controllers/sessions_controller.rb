class SessionsController < ApplicationController
  def new
    @title = %(Connexion)
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      @title = %(Connexion Invalide)
      flash.now[:error] = %(Connexion Invalide)
      render :new
    else
      sign_in user
      redirect_to root_path
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
