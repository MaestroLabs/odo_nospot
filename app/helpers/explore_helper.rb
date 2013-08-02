module ExploreHelper
    def toggle_upvote_button(content,user)
      if user.flagged?(content, :upvote)
        link_to "Unvote", :action => 'upvote',:user_id => session[:user_id],:id => content.id,:filter => @public
      else 
        link_to "Upvote", :action => 'upvote',:user_id => session[:user_id],:id => content.id,:filter => @public
      end
    end
    
    include ActsAsTaggableOn::TagsHelper
end


 