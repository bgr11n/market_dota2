$(document).on 'ready page:load', ->
  $('.edit-listing-btn').on 'click', (e) ->
    btn = $(this)
    $.get "/listings/#{btn.data('lid')}", (data) ->
      matchData data

  do managePriceAndBuyPrice

matchData = (data) ->
  $('#for-edit form').attr 'action', "/listings/#{data.listing.id}"
  $('#for-edit img').attr('src', "#{data.item.icon_url}/62x62f").css('border-color', if data.item.name_color then '#' + data.item.name_color else '#D2D2D2' )
  $('#for-edit h3').text data.item.market_name
  $('#for-edit span.type').text data.item.type
  $('#for-edit #price').val data.listing.price / 100
  $('#for-edit #buy-price').val data.listing.buy_price / 100

managePriceAndBuyPrice = ->
  @baseFee = window.app.fee
  $("#for-edit #price").bind "keyup change", ->
    price = +$(this).val()
    if price > 0
      newBuyPrice = (price * fee(price)).toFixed(2)
      $("#for-edit #buy-price").val newBuyPrice

  $("#for-edit #buy-price").bind "keyup change", ->
    buyPrice = +$(this).val()
    if buyPrice > 0
      newPrice = (buyPrice / fee(buyPrice)).toFixed(2)
      $("#for-edit #price").val newPrice

fee = (val) ->
  base = if +val <= 0.07 then 0.6 else @baseFee
  1 + base

$(document).on 'submit','#for-edit form', (e) ->
  $("#for-edit .errors").addClass 'hide'
  fieldForValidation = ["#for-edit #price", "#for-edit #buy-price"]
  errors = []
  for field in fieldForValidation
    $(field).parent().removeClass 'has-error'
    unless valid field
      $(field).parent().addClass 'has-error'
      $("#for-edit .errors").removeClass 'hide'
      $("#for-edit .errors p").text 'Необходимо указать действительную цену.'
      errors.push false
  errors.length == 0

valid = (field) ->
  val = +$(field).val()
  val > 0
