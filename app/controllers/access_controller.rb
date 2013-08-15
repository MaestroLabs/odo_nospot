class AccessController < ApplicationController
  before_filter :confirm_logged_in, :except => [:about, :contact, :attempt_login, :logout, :index,:register,:createuser,:activate,:resendtoken,:confirmtoken, :sendpasstoken, :resetpassword, :confirmNewToken, :confirmedNowNewPassword]
  before_filter :current_user
  
 
#----------------------Login/SignUp Section-------------------------------------  
  
  #homepage
  def index
    if session[:user_id] #redirects user to editors picks section if logged in
      redirect_to(:controller => 'explore', :action => 'editorspicks')
    end
  end
  
  #Sign Up Page
  def register
    @user=User.new
  end
  
  #Creates the User once the user submits their information 
  def createuser
    #Instantiate a new object using form parameters
    @user= User.new(params[:user])
    #@user.activated=false
    #Save the object
    if @user.save #sends activation email if save works
      #If save succeeds redirect to the list action
      UserMailer.request_access(@user).deliver
     # flash[:notice]="Email Activation Sent."
      redirect_to(:action => 'activate')
    else
      #If save fails, redisplay the form so user can fix problems
      render('register')
    end
  end
  
  #attempts to log in the user once they hit the submit button on the homepage
  def attempt_login
    authorized_user = User.authenticate(params[:email], params[:password])
    if !authorized_user #if user entered the wrong email or password
      flash[:error] = "Invalid email/password combination."
      redirect_to(:action => 'index')
    elsif authorized_user && authorized_user.activated == false || authorized_user.activated == "f" #if the user has not activated their account
       flash[:error] = "You have not activated your account"
       redirect_to(:action => 'activate')
    elsif authorized_user && authorized_user.activated == true || authorized_user.activated == "t" #if the user enters the right info and has activated their account
      session[:user_id]=authorized_user.id
      session[:email]=authorized_user.email
      # flash[:notice] = "You are logged in"
      redirect_to(:controller => 'explore', :action => 'editorspicks',:user_id=>authorized_user.id)
    end 
  end
  
  #logs out the user
  def logout 
      session[:user_id]=nil
      session[:email]=nil
      flash[:notice] = "Logged Out"
      redirect_to(:action => 'index')
  end
#---------------------------------------------------------------------


#-----------------------Activate Account Section----------------------  
  
  #activate account page
  def activate
    
  end
  
  #resends the activation token to the user 
  def resendtoken
    @user=User.find_by_email(params[:email])
    if @user
      UserMailer.registration_confirmation(@user).deliver
      flash[:notice]="Resent Email"
      redirect_to(:action => 'activate')
    else
      flash[:error]="This email has not been used for registration. Please verify your email and try again."
      render('activate')
    end      
  end
  
  #checks to see if user has entered the correct token for activation
  def confirmtoken
    activate_user = User.activate(params[:token])
    if activate_user
      activate_user.activated = true
      activate_user.save
      flash[:notice]="Account Activated"
      redirect_to(:action => 'index')
    else
      flash[:error]="Invalid Token"
      redirect_to(:action => 'activate')
    end
  end
#-------------------------------------------------------------------------------  
  
  
#---------------Forgot Password Section-------------------------------------------
  
  #sends user confirmation token in order to reset their password
  def sendpasstoken #when user forgets password
    @user=User.find_by_email(params[:email])
    if @user
      @user.save
      UserMailer.reset_password(@user).deliver
      flash[:notice]="Please check your email for your confirmation token"
      redirect_to(:action => 'resetpassword')
    else
      flash[:error]="This email has not been used for registration. Please verify your email and try again."
      redirect_to(:action => 'resetpassword')
    end      
  end
  
  #checks to see if user has entered the right token to reset their password
  def confirmNewToken
    @activate_user = User.activate(params[:token])
    if @activate_user
      flash[:notice]="Thank you for entering your token. Reset your password below."
      render('newpassword')
    else
      flash[:error]="Invalid token. Please enter your email for a new token."
      redirect_to(:action => 'resetpassword')
    end
  end
  
  #updates user info with correct password
  def confirmedNowNewPassword
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice]="Your password has been reset successfully. Please log in."
      redirect_to(:controller => 'access', :action => 'index')
    else
      #If save fails, redisplay the form so user can fix problems
      flash[:error]="Your passwords did not match. Please try again."
      redirect_to(:action => 'confirmNewToken', :token => @user.token)
    end
  end
 #---------------------------------------------------------------------------------- 
 
 
  def reportContent
    @content=Content.find(params[:id])
    UserMailer.report_content(@content).deliver
    flash[:notice]="Thank you for bringing this to our attention"
    redirect_to(:back)     
  end
  
  def permissionGranted
    @user = User.find(params[:id])
    @user.update_attributes(:activate => true)
    UserMailer.permission_granted(@user).deliver
  end
  
end