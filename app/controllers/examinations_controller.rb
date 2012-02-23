class ExaminationsController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :admin_user,   :only => [:edit, :update, :destroy]
  
  def index
    @title = %(All Examinations)
    @examinations = Examination.paginate(:page => params[:page])
  end

  def show
    begin
      @examination = Examination.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = %(The examination record requested is invalid.)
      @title = %(All Examinations)
      @examinations = Examination.paginate(:page => params[:page])
      redirect_to examinations_path
    end
  end

  def edit
    begin
      @title = %(Edit Examination)
      @examination = Examination.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = %(Examination record not found.)
      redirect_to examinations_path
    end
  end

  def update
    begin
      begin
        @examination = Examination.find(params[:id])
        if @examination.update_attributes(params[:examination])
          flash[:success] = %(Succesfully updated examination)
          redirect_to @examination
        else
          @title = %(Edit Examination)
          render :edit
        end
      rescue ActiveRecord::RecordNotFound
        flash[:error] = %(Examination record not found.)
        redirect_to examinations_path
      end
    rescue ActiveRecord::StaleObjectError
      flash[:error] = %(Examination has been changed by someone else)
      redirect_to edit_examination_path(@examination)
    end
  end

  def destroy
    begin
      @examination = Examination.find(params[:id])
      @examination.destroy
      flash[:success] = %(Examination record was destroyed)
      redirect_to examinations_path
    rescue ActiveRecord::RecordNotFound
      flash[:error] = %(Examination record not found)
      redirect_to examinations_path
    end
  end

private

  def admin_user
    redirect_to examinations_path if !current_user.admin?
  end
end
