$(document).on 'page:change', ->

  $("#submitTagForm").on 'click', ->

    $("#new_tag").submit

  $('#autoUserTag').autocomplete
    serviceUrl: '/tags/suggest'


    onSelect: (suggestion) ->
      #alert 'You selected: ' + suggestion.value + ', ' + suggestion.data