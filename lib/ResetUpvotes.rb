class ResetUpvotes  
  def resetDailyUp
    contents=Content.where(:privacy=>true)
    contents.each do |content|
      content.update_attributes(:dailyupvotes=>0)
    end
  end
  handle_asynchronously :resetDailyUp, :run_at => Proc.new { 2.minutes.from_now }
end