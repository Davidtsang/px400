# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "page:change", ->
  $('input[name="wd"]').val("")

  $('#site-search').submit ->
    # Let's find the input to check
    #input = $(this).find('input[name=wd]')
    #v = $input.val + 'site:400px.net'
    v = $('input[name="wd"]').val()
    $('input[name="wd"]').val(v + " site:400px.cn")

  $('[rel=nav-notice]').click ->
    return false

  $('[rel=nav-notice]').popover(
    trigger: 'click'
    placement: 'bottom'
    html: 'true'
    title: '<h4><i class="fa fa-bell"></i> 你最近的通知</h4>'
    content: ->
      return notice_pop_content()


    template: '<div class="popover nav-notice" role="nav-notice"  ><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content" id="notice_pop_content"></div><div class="popover-footer"><a class="all-notice" href="/notifications">查看全部 »</a></div></div>').on 'shown', ->
      #hide any visible comment-popover
      $('[rel=nav-notice]').not(this).popover 'hide'
      $this = $(this)
      return

  notice_pop_content = ->
    $.ajax(
      url: '/remote_notice_data'
      dataType: 'html'
      async: true
      success: (response) ->
        #alert(response)
        $('#notice_pop_content').html response)


    return '<p class="xy-center"><i class="fa fa-cog fa-spin"></i> 正在读取...</p>'

  $('body').on 'click', (e) ->
    $('[rel=nav-notice]').each ->
      #the 'is' for buttons that trigger popups
      #the 'has' for icons within a button that triggers a popup
      #alert 'kkk'
      if !$(this).is(e.target) and $(this).has(e.target).length == 0 and $('.popover').has(e.target).length == 0
        $(this).popover 'hide'
      return
    return