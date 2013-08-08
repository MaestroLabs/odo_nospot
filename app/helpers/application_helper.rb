module ApplicationHelper
    def status_tag(boolean, options={})
    options[:true]        ||= ''
    options[:true_class]  ||= 'status true'
    options[:false]        ||= ''
    options[:false_class]  ||= 'status false'
    
    if boolean
      content_tag(:span, options[:true], :class => options[:true_class])
    else
      content_tag(:span, options[:false], :class => options[:false_class])
    end
  end
  
  #displays errors of the validations that the user did not fulfill
  def error_messages_for( object )
    render(:partial => 'shared/error_messages', :locals => {:object => object})
  end
  
  #To add CSS class to links (e.g. bold current page)
 def cp(path) 
    "active" if current_page?(path)
 end
  
 #returns youtube thumbnail image
 def youtube_img(youtube_url)
  if youtube_url[/youtu\.be\/([^\?]*)/]
    youtube_id = $1
  else
    # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
    youtube_id = $5
  end

  %Q{<img src="http://img.youtube.com/vi/#{ youtube_id }/0.jpg" alt="">}
 end

 #returns youtube iframe
 def youtube_embed(youtube_url)
  if youtube_url[/youtu\.be\/([^\?]*)/]
    youtube_id = $1
  else
    # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
    youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
    youtube_id = $5
  end

    %Q{<div class="iframe-percent"><iframe title="YouTube video player" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe></div>}
 end
  
 #returns iframe of link
 def article_iframe(article_url)
    %Q{<div class="iframe-percent"><iframe src="#{article_url}" frameborder="0"></iframe></div>}
 end
 
end