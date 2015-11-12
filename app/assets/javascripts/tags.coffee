# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->

  bindEvent = ->
    $(".skill_tag").on "mouseover", ->
      linkid = $(this).data("linkid")
      $("#"+ linkid).attr("class", "show-i tag_del_link")
    $(".skill_tag").on "mouseleave", ->
      linkid = $(this).data("linkid")
      $("#"+ linkid).attr("class", "hide tag_del_link")

  bindEvent()

  $("#new_tag").on "ajax:complete", ->

    bindEvent()

  $("a").on "ajax:complete", ->

    bindEvent()

$(document).ready ready
$(document).on "page:change", ready

