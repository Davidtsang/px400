# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  $(".skill_tag").on "mouseover", ->
    linkid = $(this).data("linkid")
    $("#"+ linkid).attr("class", "show-i")
  $(".skill_tag").on "mouseleave", ->
    linkid = $(this).data("linkid")
    $("#"+ linkid).attr("class", "hide")
$(document).ready ready
$(document).on "page:change", ready
