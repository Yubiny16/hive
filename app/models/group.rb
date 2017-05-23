class Group < ApplicationRecord
  validates_presence_of :name
validates_presence_of :school
validates_presence_of :password
end
