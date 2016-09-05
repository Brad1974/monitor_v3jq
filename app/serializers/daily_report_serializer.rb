class DailyReportSerializer < ActiveModel::Serializer
  attributes :id, :child_id, :poopy_diapers, :wet_diapers, :date, :bullying_incident, :bullying_report, :ouch_incident, :ouch_report
  has_many :kind_acts
end
