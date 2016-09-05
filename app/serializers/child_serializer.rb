class ChildSerializer < ActiveModel::Serializer
attributes :id, :name, :birthdate, :bully_rating, :ouch_rating, :diapers_inventory
has_many :kind_acts
has_many :gifts
has_many :daily_reports
end
