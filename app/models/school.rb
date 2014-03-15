class School < ActiveRecord::Base
  has_many :students
  has_many :grades
  has_many :professors
  has_many :student_from_excels
  attr_accessible :name
  validates :name, :presence => {:error => 'cannot be blank'}
end
