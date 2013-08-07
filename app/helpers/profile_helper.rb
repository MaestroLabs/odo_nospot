module ProfileHelper
  
  #changes the link to upvote or unvote depending on previous status
  def toggle_upvote_button(content,user)
      if user.flagged?(content, :upvote)
        link_to "Unvote", :action => 'upvote',:user_id => content.user_id,:id => content.id
      else 
        link_to "Upvote", :action => 'upvote',:user_id => content.user_id,:id => content.id
      end
  end
    
  include ActsAsTaggableOn::TagsHelper
end
