class UserMailer < ActionMailer::Base
  def registration_confirmation(user) 
   @user = user
   mail(:from => "noreply@maestro-labs.com", :to => user.email, :subject => "Welcome to OneDoorOpen, #{user.first_name}!")
  end 
  
  def reset_password(user) 
   @user = user
   mail(:from => "noreply@maestro-labs.com", :to => user.email, :subject => "OneDoorOpen | Reset your password, #{user.first_name}!")
  end 

 def report_content(content)
   @content = content
    mail(:from => "noreply@maestro-labs.com", :to => ["cobi@maestro-labs.com","gloria@maestro-labs.com","foo@maestro-labs.com"], :subject => "Houston, we may have a problem")
  end
  
 def request_access(user)
    @user = user
    mail(:from => "noreply@maestro-labs.com", :to => ["cobi@maestro-labs.com","gloria@maestro-labs.com","foo@maestro-labs.com"], :subject => "#{user.first_name} #{user.last_name} requests permission to board")
  end
  
  def permission_granted(user) 
   @user = user
   mail(:from => "noreply@maestro-labs.com", :to => user.email, :subject => "Welcome to OneDoorOpen, #{user.first_name}!")
  end 
  
  
end

