# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#ready = ->
#  #alert( $.cookie("visit_work_time") );
#  path =window.location.pathname
#  path_arr = path.split("/")
#
#  if path_arr.length == 3 && path_arr[1] == "works"
#    #alert(path_arr.length)
#    work_id = path_arr[2]
#    #get cookie
#    visit_cookie = $.cookie("visit_work_#{work_id}")
#    alert visit_cookie
#
#$(document).ready(ready)

$(document).on "page:change", ->



  #send ajax to pv count

  $(".work-item-image").hover ->
    #alert("ok")
    info = $(this).parent().children('.work-item-frame-info')
    #alert(info)
    info.show()

  $(".work-item-frame-info").mouseleave ->
    #alert("ok")
    #info = $(this).parent().children('.work-item-frame-info')
    #alert(info)4


  #get path
  #pathname = window.location.pathname




  #likes +1
  $("#likes-submit-link").click ->
    #$('#new_works_like').submit()
    #check user ablite
    $.ajax $('#likes-submit-link').attr('href'),
      type: 'POST'
      dateType: 'json'
      data:{}
      error: (jqXHR, textStatus, errorThrown) ->
        alert textStatus
      success: (data, textStatus, jqXHR) ->
        if data["success"] == true
          #alert 'ok!'
          #change page status
          #likes +1
          currentValue = $("#work-likes-count").text()
          newValue = +currentValue + 1
          $("#work-likes-count").text(newValue)

          #like to unlike
          $('#submit-link-span').text("已赞")
          #$('#likes_submit_link').attr('href',"#")


    return false

  #like -1
  $("#unlikes_sumbit_link").click ->
    $.ajax $('#unlikes_sumbit_link').attr('href'),
      type: 'POST'
      dateType: 'json'
      data:{}
      error: (jqXHR, textStatus, errorThrown) ->
        alert textStatus
      success: (data, textStatus, jqXHR) ->
        if data["success"] == true
          #alert 'ok!'
          #likes +1
          currentValue = $("#work-likes-count").text()
          newValue = +currentValue - 1
          $("#work-likes-count").text(newValue)

          $('#submit-link-span').text("已取消")
    #user name file show ok
    return false

    #thank +1
  $("#thanks-submit-link").click ->
    #$('#new_works_like').submit()
    #check user ablite
    $.ajax $('#thanks-submit-link').attr('href'),
      type: 'POST'
      dateType: 'json'
      data:{}
      error: (jqXHR, textStatus, errorThrown) ->
        alert textStatus
      success: (data, textStatus, jqXHR) ->
        if data["success"] == true
          #alert 'ok!'
          #change page status
          #likes +1
          currentValue = $("#thanks-count").text()
          newValue = +currentValue + 1
          $("#thanks-count").text(newValue)

          #like to unlike
          $('#thanks-link-span').text("已感谢")
    #$('#likes_submit_link').attr('href',"#")


    return false


  #thank -1
  $("#unthanks_sumbit_link").click ->
    $.ajax $('#unthanks_sumbit_link').attr('href'),
      type: 'POST'
      dateType: 'json'
      data:{}
      error: (jqXHR, textStatus, errorThrown) ->
        alert textStatus
      success: (data, textStatus, jqXHR) ->
        if data["success"] == true
          #alert 'ok!'
          #likes +1
          currentValue = $("#thanks-count").text()
          newValue = +currentValue - 1
          $("#thanks-count").text(newValue)

          $('#thanks-link-span').text("已取消")
    #user name file show ok
    return false