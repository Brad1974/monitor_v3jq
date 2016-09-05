class KindAct < ApplicationRecord
  belongs_to :giver, :class_name => 'Child'
  belongs_to :recipient, :class_name => 'Child'
  belongs_to :daily_report

  validate :consistent_data

  def consistent_data
    # binding.pry
    if self.act.length > 0 && self.recipient_id == nil
      errors.add(:recipient_id, "if you enter in a kind act, you need to also select a recipient")
    elsif  self.act.length == 0 && recipient_id != ""
      errors.add(:recipient_id, "if you enter in a recipient of a kind act, you need to also describe the act")
    end
  end

  #
  # def bullying_data_consistent
  #   if bullying_incident == true && bullying_report == ""
  #     errors.add(:bullying_report, " If you clicked that there was bullying today, you must fill out a bullying report")
  #   elsif bullying_incident == false && bullying_report != ""
  #     errors.add(:bullying_report, " If you filled out a bullying report, you need to check the box for bullying too")
  #   end
  # end

end
