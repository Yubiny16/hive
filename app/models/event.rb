class Event < ApplicationRecord
  validates :title, presence: true
  require 'date'
  attr_accessor :date_range

  def all_day_event?
    self.start == DateTime.now.midnight && self.end == DateTime.now.midnight ? true : false
  end
end
