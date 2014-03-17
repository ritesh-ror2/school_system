class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home, :new_registration_with_cpf, :create_registration_with_cpf, :parent_or_student_signup]
  
  def home
  end
  
  def index
    if current_user.is_parent?
      @students = Parent.find_by_user_id(current_user.id).student_from_excels
      @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @students.first.current_grade, @students.first.school_id)
    end  
    
    if current_user.is_student?
      @student = Student.find_by_user_id(User.find_by_id(current_user.id)).student_from_excel
      @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @student.current_grade, @student.school_id)
    end
    @average = calculate_average @grades
  end
  
  def create_registration_with_cpf
    @cpf = params[:cpf]
    @role = params[:user]
    @student = StudentFromExcel.find_by_cpf(@cpf)
    if @student.nil?
      redirect_to new_registration_with_cpf_users_path, :notice => "student with given cpf was not found"
    elsif @role == 'student' && !Student.find_by_student_from_excel_id(@student.id.to_s).nil?
      redirect_to root_path, :notice => "student was already signup with this cpf #{@cpf}"
      return 
    elsif @role == 'parent' && @student.student_parents.size == 2    
      redirect_to root_path, :notice => "There are already two parents signup with this cpf #{@cpf}"
      return
    end  
    render ask_question_users_path
  end
  
  def change_student
    @student = StudentFromExcel.find_by_id(params[:id])
    @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", @student.current_grade, @student.school_id)
    @average = calculate_average @grades
  end
  
  def change_subjects
    @subjects = params[:sub].split(",")
    @subjects = 'all' if @subjects.first=="select_all" 
    student = StudentFromExcel.find_by_id(params[:stid]) if current_user.is_parent?
    student = Student.find_by_user_id(current_user.id).student_from_excel if current_user.is_student?
    @grades = GradeFromExcel.where("grade_name = ? and school_id = ?", student.current_grade, student.school_id)
    @subjects = @grades.select{|grade| @subjects.include?(grade.subject_name)} if @subjects!="all" 
    if @subjects == 'all'
      @average = calculate_average @grades
    else
      @average = calculate_average @subjects
    end  
  end
  
  def calculate_average grades
    average = 0
    grades.each{|grade| average = average + grade.subject_average}
    average = (average/grades.size).round(2)  if average > 0
  end
   
  def new_registration_with_cpf
    @role = params[:role]
  end
  
  def parent_or_student_signup
  end
  
end
