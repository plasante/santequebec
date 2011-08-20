module ApplicationHelper
  #Return a title on a per-page basis.
  def title
    base_title = %(Sant&eacute; Qu&eacute;bec)
    if @title.nil?
      base_title
    else
      "#{base_title} - #{@title}"
    end
  end
  
  def header
    base_header = %(Sant&eacute; Qu&eacute;bec)
    if @header.nil?
      base_header
    else
      "#{base_header} - #{@header}"
    end
  end
end
