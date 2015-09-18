startTimer = (display) ->
  timer = display.data('left')
  timerInterval = setInterval ->
    hours = parseInt(timer / 3600, 10)
    minutes = parseInt((timer / 60) % 60, 10)
    seconds = parseInt(timer % 60, 10)

    hours = if hours < 10 then "0" + hours else hours
    minutes = if minutes < 10 then "0" + minutes else minutes
    seconds = if seconds < 10 then "0" + seconds else seconds

    display.text(hours + ":" + minutes + ":" + seconds)

    if --timer < 0
      clearInterval timerInterval
  , 1000

$(document).on 'ready page:load', ->
  passTime = $('#pass-time')
  startTimer(passTime) if passTime

  $('#user-tab a').click (e) ->
    e.preventDefault()
    $(this).tab('show')

  $("ul.nav-tabs > li > a").on "shown.bs.tab", (e) ->
    id = $(e.target).attr("href").substr(1)
    window.location.hash = id

  $('#user-tab a[href="' + window.location.hash + '"]').tab('show')
