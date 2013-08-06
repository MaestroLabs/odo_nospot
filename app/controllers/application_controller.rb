class ApplicationController < ActionController::Base
  protect_from_forgery
  

  
  protected
  #checks to see if user is logged in
  def confirm_logged_in
    unless session[:email]
      flash[:error] = "Please log in or register."
      redirect_to(:controller => 'access', :action => 'index')
      return false #halts the before_filter
     else
       return true
    end
  end
  
  #checks to see if user is an editor
  def confirm_editor
    if session[:user_id]!=nil
      @user=User.find(session[:user_id])
      if !@user.editor
      #flash[:error] = "Please log in or register."
        redirect_to(:controller => 'access', :action => 'index')
        return false #halts the before_filter
     else
       return true
      end
   else
     redirect_to(:controller => 'access', :action => 'index')
   end
  end
  

  private
  #if user is logged in, create @user variable
  def current_user
     @user||=User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
end
