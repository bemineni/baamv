module ApplicationHelper

  def getTitle(title)
      maintitle="I am Zero"
      if title.empty?
          maintitle
      else
         "#{maintitle} | #{title}"
      end
  end

  def codeHighlight(text)
		text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
				"<div class=\"codeblock img-rounded\">" + highlight_code($2, $3) + "</div>"
		end
  end

end
