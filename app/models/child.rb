class Child < ApplicationRecord
  has_many :daily_reports, dependent: :destroy
  has_many :kind_acts, :class_name => KindAct, :foreign_key => 'giver_id'
  has_many :gifts, :class_name => KindAct, :foreign_key => 'recipient_id'

  validates :first_name, presence: { message: "You must enter a first name" }
  validates :last_name, presence: { message: "You must enter a last name" }
  validate :proper_age
  validates :diapers_inventory, numericality: { only_integer: true, message: "You must enter a number in diapers inventory field"}

  scope :troublemakers, -> {where("bully_rating > 2")}

  def proper_age
    if (DateTime.now - birthdate < 365)
      errors.add(:birthdate, "Children must be at least one year old to enroll")
    end
  end

  def name
    self.first_name + " " +self.last_name
  end

  def update_child_stats(dailyreport)
    self.diapers_inventory -= dailyreport.total_daily_diapers
    self.bully_rating += dailyreport.bullying_today
    self.ouch_rating += dailyreport.ouches_today
    self.save
  end

  def remove_stats(report)
    self.diapers_inventory += report.total_daily_diapers
    self.bully_rating -= report.bullying_today
    self.ouch_rating -= report.ouches_today
    self.save
  end

  def self.child_with_highest_ouch_rating
    if Child.all.detect {|c| c.ouch_rating > 0}
      c = (Child.all.sort_by {|c| c.ouch_rating}.reverse)
      s = c.select{|f| f.kind_acts.count == c[0].kind_acts.count}
      if s.length == 1
        " #{s[0].name} has the highest ouch rating of the class with #{s[0].ouch_rating} reported ouch incidents. "
      else
        "#{s.collect{|s| s.name}.join(', ')} lead the class with #{s[0].ouch_rating} reported ouch incidents each."
      end
    end
  end

  def self.child_with_most_poops
    if self.count > 0 && self.all.detect {|c| c.daily_reports.detect {|dr| dr.poopy_diapers > 0}}
      c = joins(:daily_reports).group(:child_id).sum(:poopy_diapers)
      largest= c.max_by{|k,v| v}
      " #{Child.find(largest[0]).name} is the biggest pooper with #{largest[1]} reported poops. "
    end
  end

  def self.daily_biggest
    ranking = DailyReport.order(poopy_diapers: :desc)
    s = ranking.select{|w| w.poopy_diapers == ranking[0].poopy_diapers}
    if s.length == 1
      " #{s[0].child.name} has the most poops in a single day with #{s[0].poopy_diapers} reported poops. "
    else
      "#{s.collect{|s| s.child.name}.join(', ')} lead the class with #{s[0].poopy_diapers} reported poops in a day each."
    end
  end

  def self.child_with_most_kind_acts
    if Child.all.detect {|c| c.kind_acts.count > 0}
      c = (Child.all.sort_by {|c| c.kind_acts.count}.reverse)
      s = c.select{|f| f.kind_acts.count == c[0].kind_acts.count}
      if s.length == 1
        " #{s[0].name} peformed the most kind acts of the class with #{s[0].kind_acts.count} reported acts of kindness. "
      else
        "#{s.collect{|s| s.name}.join(', ')} lead the class with #{s[0].kind_acts.count} reported acts of kindness each."
      end
    end
  end

  def self.child_who_received_most_kind_acts
    if Child.all.detect {|c| c.gifts.count > 0}
      c = (Child.all.sort_by {|c| c.gifts.count}.reverse)
      s = c.select{|f| f.gifts.count == c[0].gifts.count}
      if s.length == 1
        " #{s[0].name} received the most kind acts of the class with #{s[0].gifts.count} reported acts of kindness. "
      else
        "#{s.collect{|s| s.name}.join(', ')} lead the class with #{s[0].gifts.count} reported gifts of kindness each."
      end
    end
  end
end
