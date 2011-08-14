module ApplicationHelper
  #Return a title on a per-page basis.
  def title
    base_title = %(Santé Québec)
    if @title.nil?
      base_title
    else
      "#{base_title} - #{@title}"
    end
  end
  
  def header
    base_header = %(Santé Québec)
    if @header.nil?
      base_header
    else
      "#{base_header} - #{@header}"
    end
  end
end
