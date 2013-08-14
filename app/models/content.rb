class Content < ActiveRecord::Base
  
  # #include ActionView::Helpers
  # include ApplicationController.helpers.name_visible?
   # before_save :name_visible?
   
  acts_as_taggable_on :tags
  
  make_flaggable :upvote
  
  scope :sorted, order('contents.title ASC')
  scope :privacy, where(:privacy => true)
  
  # attr_accessible :title, :body
  belongs_to :folder
  attr_accessible :title, :file_type, :content_type, :privacy, :link, :description, :user_id, :avatar, :name, :tag_list, :upvotes, :quote, :publishedBy, :dailyupvotes, :lastupvoted
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
  
  no_whitespace = /^[\S]+$/
  
  # validates_length_of :description, :maximum => 200, :message => "Please limit the description to 200 characters."
  validates :content_type, :presence => true
  validates_presence_of :quote, :if => :article?
  validates_presence_of :link, :if => :video?
  validates_presence_of :views, :if => :image2?,:message => "Can't do both"
  validates_presence_of :avatar, :if => :image?
  validates_format_of :link, :with => /^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/, :if => :video?
  validates_format_of :link, :with => /\.(png|jpg|gif|jpeg)$/, :if => :imagelink?
  validates_format_of :link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :if => :article?
  validates :title, :presence => true
  validates :description, :presence => true
  validates :tag_list, :presence => true#,:format => no_whitespace
  # validates_format_of :link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :if => :article?
   validates_attachment_content_type :avatar,
     :content_type => ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],  :message => "Not a valid image file (jpg, jpeg, png, gif)",
     :if => :is_type_of_image?    
     
  def article?
    content_type == "Article"
  end
  
  def video?
    content_type == "Video"
  end
 
  def imagelink?
    link.blank? == false && avatar.blank? == true && content_type == "Image" #&& avatar ==nil && link !=nil #|| avatar!=nil && link!=nil
  end
  
  def imageupload?
    content_type == "Image" && avatar == true#|| avatar!=nil && link!=nil)
  end
  
  def image?
    content_type == "Image" && avatar.blank? == true && link.blank? == true
  end
  
  def image2?
    content_type == "Image" && avatar.blank? ==false && link.blank? == false
  end
  
      protected
  def is_type_of_image?
    avatar.content_type =~ %r(image)
  end


end
