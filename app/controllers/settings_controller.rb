class SettingsController < ApplicationController
  before_filter :confirm_logged_in, :except => :thanks
  before_filter :current_user
  
  def settingspage
    @user=User.find(session[:user_id])
  end

  def updateInformation
    #Find object using form parameters
    @user = User.find(session[:user_id])
    #Update the object
    if @user.update_attributes(params[:user])
      #If update succeeds redirect to the list action
      flash[:notice]="Your information has been successfully updated."
      redirect_to(:controller => 'profile', :action => 'show')
    else
      #If save fails, redisplay the form so user can fix problems
      render('settingspage')
    end
  end

  def updatePassword
    #Find object using form parameters
    @user = User.find(session[:user_id])
    #Update the object
    if @user.update_attributes(params[:user])
      #If update succeeds redirect to the list action
      flash[:notice]="Your information has been successfully updated."
      redirect_to(:controller => 'profile', :action => 'show')
    else
      #If save fails, redisplay the form so user can fix problems
      render('changepassword')
    end
  end
  
  def changepassword   
   @user = User.find(session[:user_id])
    confirm_logged_in
    if session[:user_id] != @user.id   
       flash[:error]="You do not have permission to change this user's information."
       redirect_to(:controller => 'access', :action => 'index')
    end
  end
  
  def thanks
    
  end
  
end