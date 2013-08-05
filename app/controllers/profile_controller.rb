class ProfileController < ApplicationController
  before_filter :confirm_logged_in
  before_filter :find_user
  before_filter :current_user

  def show
     @count=0 #starts at 0 to create the first row-fluid on show.html.erb
     @uptotal=0
     @contents=Content.order("contents.created_at").where(:user_id=>session[:user_id]).page(params[:page]).per_page(12)
     
      contents = Content.where(:user_id => session[:user_id],:privacy=>true)
     
     @total_items= contents.size
     
      contents.each do |content|#Calculate total upvotes
        @uptotal+=content.flaggings.size
        content.upvotes=content.flaggings.size
      end
     
     @user=User.find(session[:user_id])
    
    # if params[:search].present? && params[:filter]=="Tags"
     # tags_array= params[:search].split(/ /)
    # end
     # @search = Content.search do
       # fulltext params[:search] if params[:filter]=="Title"
       # facet :tag_list
       # order_by :created_at, :desc
       # with :user_id, session[:user_id]
       # with(:tag_list, params[:search]) if params[:search].present? && params[:filter]=="Tags" #&& Content.tagged_with(params[:search])
       # with(:tag_list).any_of(tags_array)if params[:search].present? && params[:filter]=="Tags"
       # paginate(:per_page => 12, :page => params[:page])
     # end
   # @contents = @search.results
  # if params[:search].present?
     # @contents = Content.where(:title => "%#{params[:search]}%",:user_id =>session[:user_id]).page(params[:page]).per_page(12)# \
   # # | Content.tagged_with("%#{params[:search]}%").where(:user_id => session[:user_id]).page(params[:page]).per_page(12)
  # else
    # @contents=Content.order("contents.created_at").where(:user_id=>session[:user_id]).page(params[:page]).per_page(12)
  # end
     
  end
  
  def addC
    @content=Content.new(:user_id=>session[:user_id])
  end
  
  def createC
    #Instantiate a new object using form parameters
    user=User.find(session[:user_id])
    @content= Content.new(params[:content])
    #Save the object
    @content.user_id=session[:user_id]
    if @content.name==true
      @content.file_type="Anonymous"
    end
    if @content.name==false
      @content.file_type="#{user.first_name} #{user.last_name}"
    end
    
    if user.thought_leader==true
      @content.publishedBy="thoughtleader"
    elsif user.editor==true
      @content.publishedBy="editor"
    else
      @content.publishedBy="mortal"
    end
    
    if user.id == 5 #If ODO Team profile uploads content, publishedBy => 'ODO Team' so content appears on 'Motivational Mondays, Tuesdays...' section
      @content.publishedBy="ODOTeam"
    end
    
    if @content.save
      #If save succeeds redirect to the list action
      flash[:notice]="Content Added."
      # redirect_to(:action => 'show', :user_id => @content.user_id)
      redirect_to(:back)
    else
      #If save fails, redisplay the form so user can fix problems
      render('addC')
    end
  end
  
  def updateContent  #USED TO ADD "publishedBy" TO CONTENT. REMEMBER THE DAY. JULY 29, 2013.
    @users = User.all
    @users.each do |user|
      @contents = Content.where(:user_id => user.id,:privacy=>true)
      @contents.each do |content|
        if user.thought_leader==true && user.editor==false
          content.update_attributes(:publishedBy=>"thoughtleader")
        # elsif user.editor==true
          # content.update_attributes(:publishedBy=>"editor")
        else
          content.update_attributes(:publishedBy=>"mortal")
        end
        if user.id == 5
          content.update_attributes(:publishedBy=>"ODOTeam")
        end
      end
    end
    flash[:notice] ="Nice job, Brennan! You did it!"
    redirect_to(:controller=>'access', :action => 'index')
  end  
    
  def editC
    @user = User.find(session[:user_id])
    @content = Content.find(params[:id])
  end
  
  def updateC
    #Instantiate a new object using form parameters
    user=User.find(session[:user_id])
    @content= Content.find(params[:id])
    #Save the object

    if @content.update_attributes(params[:content])
      #If save succeeds redirect to the list action
       if @content.name==true 
         @content.update_attributes(:file_type=>"Anonymous")
       end
       if @content.name==false
        @content.update_attributes(:file_type=>"#{user.first_name} #{user.last_name}")
       end
       flash[:notice]="Content Updated."
       redirect_to(:action => 'show',:user_id => @content.user_id)
    else
      #If save fails, redisplay the form so user can fix problems
      render('editC')
    end
  end
  
  def deleteC
    @content = Content.find(params[:id])
  end
  
  def explodePineapple
     @content = Content.find(params[:id])
     if session[:user_id] == @content.user_id
       @content.destroy
       flash[:notice]="This post has been deleted."
     end
     # redirect_to(:action => 'show',:user_id=>@content.user_id)
     redirect_to(:back)
  end
  
  def tagged
    @count=0
    @tagname=params[:tag]
    if params[:tag].present? 
      @contents = Content.tagged_with(params[:tag]).where(:user_id=>session[:user_id]).page(params[:page]).per_page(12)
    else 
      @contents = Content.postall.page(params[:page]).per_page(12)
    end  
  end
  
   def following
     @count = 0
     @title = "Following"
     @user = User.find(params[:id])
     @other_users=@user.followed_users#.paginate(page: params[:page])
   end
 
   def followers
     @count = 0
     @title = "Followers"
     @user = User.find(params[:id])
     @other_users = @user.followers#.paginate(page: params[:page])
   end
  
  
  def usersprofile
    #@content = Content.find(params[:id])
    @count=0
    @uptotal=0
    @other_user = User.find(params[:id])
    @contents = Content.order("contents.upvotes ASC").where(:privacy => true, :user_id => @other_user.id, :name => false)
    @user= User.find(session[:user_id])
  end
  
    def upvote
    @user=User.find(session[:user_id])
    @content=Content.find(params[:id])
    
    if @user.flagged?(@content, :upvote)
         @user.unflag(@content, :upvote)     
    else 
        @user.flag(@content, :upvote)
    end
    # redirect_to :action=>"usersprofile",:id=> params[:user_id]
    redirect_to(:back)
  end

  
    private
  
  def find_user
    if session[:user_id]
      @user = User.find_by_id(params[:user_id])
    end
  end

end
