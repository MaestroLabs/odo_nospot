class JamesController < ApplicationController
  before_filter :confirm_logged_in, :current_user
  
  def index
    
  end
end