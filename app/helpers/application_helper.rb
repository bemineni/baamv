module ApplicationHelper

  def getTitle(title)
      maintitle="I am Zero"
      if title.empty?
          maintitle
      else
         "#{maintitle} | #{title}"
      end
  end

end
