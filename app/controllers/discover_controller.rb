class DiscoverController < ApplicationController
  before_filter :current_user
  
  #Displays content info that was shared through facebook or twitter
  def c
    if Content.where(:id => params[:id]).blank?
      render(:partial=>'noContent')
    else
      @content = Content.find(params[:id])
    end   
  end
  
end
