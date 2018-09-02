class Reminder < ApplicationRecord
  validates :title, :time, :time_zone, presence: true
end
