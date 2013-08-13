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
    mail(:from => "noreply@maestro-labs.com", :to => "team@maestro-labs.com", :subject => "Houston, we may have a problem")
  end
end

