# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:change", ->
  $(".work-item-image").hover ->
    #alert("ok")
    info = $(this).parent().children('.work-item-frame-info')
    #alert(info)
    info.show()

  $(".work-item-frame-info").mouseleave ->
    #alert("ok")
    #info = $(this).parent().children('.work-item-frame-info')
    #alert(info)
    $(this).hide()

