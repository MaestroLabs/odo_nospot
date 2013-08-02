module ExploreHelper
    def toggle_upvote_button(content,user)
      if user.flagged?(content, :upvote)
        link_to "Unvote", :controller => 'explore',:action => 'upvote',:id => content.id
      else 
        link_to "Upvote", :controller => 'explore', :action => 'upvote',:id => content.id
      end
    end
    
    include ActsAsTaggableOn::TagsHelper
end


 