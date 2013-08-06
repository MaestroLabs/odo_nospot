class JamesController < ApplicationController
  before_filter :confirm_logged_in, :current_user
  
  #displays troll
  def index
    
  end
end