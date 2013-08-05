class ExploreController < ApplicationController
  before_filter :confirm_logged_in
  before_filter :current_user

  def index
    @uptotal=0
     contents = Content.order("contents.created_at DESC").where(:privacy=>true)
     contents.each do |content|#Calculate total upvotes
       @uptotal+=content.flaggings.size
       content.update_attributes(:upvotes=>content.flaggings.size)
     end
    @count=0 #starts at 0 to create the first row-fluid
    # @followers=false
    # if params[:filter]=="e" #Editors
      # @contents=Content.order("contents.upvotes DESC, contents.updated_at DESC").where(:publishedBy=>"editor",:privacy => true).page(params[:page]).per_page(12)
    # if params[:filter]=="f" #Following only shows the people the current user is following
      # @users=@user.followed_users
      # @followers=true
    if params[:filter]=="p" #Public doesn not show editors or thought leaders
      @contents=Content.order("contents.upvotes DESC, contents.updated_at DESC").where(:publishedBy=>"mortal",:privacy => true).page(params[:page]).per_page(12)
    elsif params[:filter]=="tl" #Explore shows thought_leader content only by default
      @contents=Content.order("contents.upvotes DESC, contents.updated_at DESC").where(:publishedBy=>"thoughtleader",:privacy => true).page(params[:page]).per_page(12)
    else
    redirect_to(:action => 'editorspicks')  
    end
  end
  
  def results
    if params[:filter]=="Name" && params[:search].present?
      @searchedterm = params[:search]
      @name=true
      @search = User.search do
        fulltext params[:search] do
        boost(2.0) { with(:thought_leader, true) }
        end
        #order_by :last_name, :asc
        order_by(:score, :desc)
       # with  :last_name, params[:search]
       # with :first_name, params[:search]
        paginate(:per_page => 12, :page => params[:page])
      end
      @users=@search.results
    end
    
    @user=User.find(session[:user_id])
    @count=0
    if params[:search].present? && params[:filter]=="Tags"
      tags_array= params[:search].split(/ /)
   end
   @search = Content.search do
      fulltext params[:search] if params[:filter]=="Title"
      facet :tag_list
      order_by :upvotes, :desc
      order_by :updated_at, :desc
      with :privacy, true
      with(:tag_list).any_of(tags_array)if params[:search].present? && params[:filter]=="Tags"
      paginate(:per_page => 12, :page => params[:page])
   end
   @contents = @search.results
  end
  
  def following
    @allrecords = []
    @count=0
    @uptotal=0
    @users=@user.followed_users    
    # @contents1 = Content.order("contents1.created_at DESC").where(:user_id => session[:user_id])
    # @contents1.each do |content|#Calculate total upvotes
      # @uptotal+=content.flaggings.size
      # content.update_attributes(:upvotes=>content.flaggings.size)
    # end  
     contents = Content.order("contents.created_at DESC").where(:privacy=>true)
     contents.each do |content|#Calculate total upvotes
       @uptotal+=content.flaggings.size
       content.update_attributes(:upvotes=>content.flaggings.size)
     end
  end
  
  def editorspicks
    @contentsUpvotes = Content.order("contents.dailyupvotes DESC").where(:privacy => true).limit(3)
    @contentsFromODO = Content.order("contents.created_at DESC").where(:publishedBy => "ODOTeam").limit(3)
    @contentsNewest = Content.order("contents.created_at DESC").where(:privacy=>true).where("contents" != "publishedBy", "ODOTeam").limit(20)
    @contentsGems = Content.order("contents.category_at DESC").where(:category=>"hg").limit(4)
    
    time = Time.new
    if time.wday==0
      @day = "Simple Sunday"
    elsif time.wday == 1
      @day = "Motivational Monday"  
    elsif time.wday == 2
      @day = "Treat Yo' Self Tuesday"
    elsif time.wday == 3
      @day = "Work-it Wednesday"
    elsif time.wday == 4
      @day = "Thoughtful Thursday"
    elsif time.wday == 5
      @day = "Feel-good Friday"
    elsif time.wday == 6
      @day = "Short n' Sweet Saturday"
    end    
  end

  def add
    user=User.find(session[:user_id])
    content=Content.new
    oldcontent=Content.find(params[:id])
    content=oldcontent.dup
    content.tag_list = oldcontent.tag_list
    content.avatar=oldcontent.avatar
    content.privacy=false
    content.user_id=session[:user_id]
       
    if user.thought_leader==true
      content.publishedBy="thoughtleader"
    # elsif user.editor==true
      # content.publishedBy="editor"
    else
      content.publishedBy="mortal"
    end
    
    if user.id == 5 #If ODO Team profile uploads content, publishedBy => 'ODO Team' so content appears on 'Motivational Mondays, Tuesdays...' section
      content.publishedBy="ODOTeam"
    end
    
    
    if content.save
      flash[:notice]="You've saved the content to your catalogue!"
    else
      flash[:error]="Unable to save content. Please try again."
    end
    # redirect_to(:action => 'index')
    redirect_to(:back)

  end
  
  def resetDailyUp
    user=User.find(session[:user_id])
    if user.editor
      contents=Content.where(:privacy=>true)
      contents.each do |content|
        content.update_attributes(:dailyupvotes=>0)
      end
    end
    redirect_to(:action => 'index')
  end
  #handle_asynchronously :resetDailyUp, :run_at => Proc.new { 2.minutes.from_now }
  
  def makehiddengem
    currentUser = User.find(session[:user_id])
    if currentUser.editor
      content = Content.find(params[:id])
      content.category = "hg"
      content.category_at = Time.now
      content.save
      flash[:notice]="Nice job, #{currentUser.first_name}. You've chosen this piece of content as a hidden gem!"
      redirect_to(:action => 'index')
    else
      flash[:notice]="You do not have permission to make this a hidden gem! Are you sure you're an editor?"
      redirect_to(:action => 'index')
    end
  end
  
  def removehiddengem
    currentUser = User.find(session[:user_id])
    if currentUser.editor
      content = Content.find(params[:id])
      content.category = ""
      content.save
      flash[:notice]="Hey, #{currentUser.first_name}. This content is no longer a hidden gem."
      redirect_to(:action => 'index')
    else
      flash[:notice]="Hey! You do not have permission to do this! Are you sure you're an editor?"
      redirect_to(:action => 'index')
    end
  end
   
  def upvote
    @user=User.find(session[:user_id])
    @content=Content.find(params[:id])
    
    if @user.flagged?(@content, :upvote)
         @user.unflag(@content, :upvote)
         if @content.dailyupvotes > 0
          @content.update_attributes(:dailyupvotes=>@content.flaggings.size-1)
         end     
    else 
        @user.flag(@content, :upvote)
        @content.update_attributes(:dailyupvotes=>@content.flaggings.size+1)
    end
    # redirect_to :action=>"index",:filter=>params[:filter]
    redirect_to(:back)
  end
 
  def tagged
     @count=0
    if params[:tag].present? 
      @tagname=params[:tag]
      @contents = Content.tagged_with(params[:tag]).where(:privacy => true).page(params[:page]).per_page(12)
    else 
      @contents = Content.postall.where(:privacy => true)
    end
    #render 'shared/tagged'  
  end
  
end
