class StudentStatus < ActiveRecord::Base
  attr_accessible :school_id, :status, :student_from_excel_id
  belongs_to :student_from_excel
  validate :validate_status_activation
  
  def validate_status_activation
    if self.student_from_excel.student_statuses.map(&:status).include?User.student_active and self.status == User.student_active
      errors.add(:status, "status is already active in some school")
    end
  end
  
end
