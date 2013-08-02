class RelationshipsController < ApplicationController
  before_filter :confirm_logged_in
  before_filter :current_user

  def create
    @other_user = User.find(params[:relationship][:followed_id])
    @user=User.find(session[:user_id])
	@user.follow!(@other_user)
	respond_to do |format|
      format.html {     redirect_to :controller => 'profile', :action => 'usersprofile', :id => @other_user.id }
      format.js
    end

  end

  def destroy
    @other_user = Relationship.find(params[:id]).followed
	@user=User.find(session[:user_id])
    @user.unfollow!(@other_user)
	respond_to do |format|
      format.html {     redirect_to :controller => 'profile', :action => 'usersprofile', :id => @other_user.id }
      format.js
    end

  end
end
