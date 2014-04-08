class School < ActiveRecord::Base
  has_many :students
  has_many :grades
  has_many :professors
  has_many :student_from_excels
  has_many :grade_from_excels
  has_one :school_administration
  attr_accessible :name, :student_from_excels_attributes
  validates :name, :presence => {:error => 'cannot be blank'}
  accepts_nested_attributes_for :student_from_excels
end
