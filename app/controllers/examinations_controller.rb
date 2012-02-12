class ExaminationsController < ApplicationController
  before_filter :authenticate, :only => [:index]
  
  def index
    @title = %(Examinations)
  end

  def show
  end

  def edit
  end

  def update
  end

  def new
  end
  
  def create
  end
  
  def destroy
  end

end
