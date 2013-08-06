class ManageusersController < ApplicationController
  before_filter :confirm_editor
  before_filter :current_user
  
  #renders 'list' page
  def index
    list
    render('list')
  end
  
  #shows all current users registered on the site
  def list
    @users=User.sorted
  end

  #shows additional info about user
  def show
    @user = User.find(params[:id])
  end
  
  #allows editor to edit user info
  def edit
     @user = User.find(params[:id])
  end
   
  #updates the user with submitted changes from edit
  def update
    #Find object using form parameters
    @user = User.find(params[:id])
    #Update the object
    if @user.update_attributes(params[:user])
      #If update succeeds redirect to the list action
      flash[:notice]="User updated."
      redirect_to(:action => 'list', :id => @user.id)
    else
      #If save fails, redisplay the form so user can fix problems
      render('edit')
    end
   end
   
   #delete confirmation page
   def delete
     @user = User.find(params[:id])
   end
   
   #deletes user
   def destroy
     User.find(params[:id]).destroy
     flash[:notice]="User destroyed."
     redirect_to(:action => 'list')
   end

end
