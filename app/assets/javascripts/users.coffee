$(document).on 'ready page:load', ->
  $('#user-tab a').click (e) ->
    e.preventDefault()
    $(this).tab('show')

  $("ul.nav-tabs > li > a").on "shown.bs.tab", (e) ->
    id = $(e.target).attr("href").substr(1)
    window.location.hash = id

  $('#user-tab a[href="' + window.location.hash + '"]').tab('show')
