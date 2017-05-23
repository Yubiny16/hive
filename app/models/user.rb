class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :messages
  has_many :conversations, foreign_key: :sender_id

    validates_presence_of :school
    validates_presence_of :class_year
    validates_presence_of :first_name
    validates_presence_of :last_name
    validates_presence_of :major
    
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
