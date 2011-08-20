class PagesController < ApplicationController
  def home
    set_title_header( %(Acceuil) )
  end

  def aide
    set_title_header( %(Aide) )
  end
  
  def apropos
    set_title_header( %(A Propos) )
  end
  
  private
  
  def set_title_header( text )
    @title = @header = text
  end
end
