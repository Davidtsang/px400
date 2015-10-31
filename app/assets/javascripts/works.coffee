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

  #show page
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
