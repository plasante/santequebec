class ExaminationsController < ApplicationController
  before_filter :authenticate, :only => [:index]
  
  def index
    @title = %(All Examinations)
    @examinations = Examination.paginate(:page => params[:page])
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
