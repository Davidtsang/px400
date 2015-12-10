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
    $('input[name="wd"]').val(v + " site:400px.net")





#  $('a[href=\'#top\']').click ->
#    $('html, body').animate { scrollTop: 0 }, 'slow'
#    false