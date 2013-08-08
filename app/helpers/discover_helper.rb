module DiscoverHelper
  
 def youtube_embed_disc(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end
  
      %Q{<div class="iframe-percent-disc"><iframe title="YouTube video player" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe></div>}
 end
  
 #returns iframe of link
 def article_iframe_disc(article_url)
    %Q{<div class="iframe-percent-disc"><iframe src="#{article_url}" frameborder="0"></iframe></div>}
 end
  
end
