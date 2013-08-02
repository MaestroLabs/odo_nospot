class ManageusersController < ApplicationController
  before_filter :confirm_editor
  before_filter :current_user
  
  def index
    list
    render('list')
  end
  
  def list
    @users=User.sorted
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
     @user = User.find(params[:id])
  end
   
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
   
   def delete
     @user = User.find(params[:id])
   end
   
   def destroy
     User.find(params[:id]).destroy
     flash[:notice]="User destroyed."
     redirect_to(:action => 'list')
   end

end
