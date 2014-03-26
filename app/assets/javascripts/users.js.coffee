# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $("#student_list").live "change", ->
    $.get('/users/change_student?id='+$(this).val())

  $("#select_subject").dropdownchecklist
    emptyText: "Please select subjects."
    firstItemChecksAll: true
    width: 190
    maxDropHeight: 200
    icon: {placement:'right'}
     
      
  $('#select_subject').live "change", ->
    $.get('/users/change_subjects?stid='+$("#student_list").val()+'&sub='+$(this).val())  
    
  
