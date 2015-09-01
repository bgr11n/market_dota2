$(document).on 'ready page:load', ->
  $('.edit-listing-btn').on 'click', (e) ->
    btn = $(this)
    $.get "/listings/#{btn.data('lid')}", (data) ->
      $('#for-edit .loader').addClass 'hide'
      matchData data
      $('#for-edit .item-content').removeClass 'hide'

  do managePriceAndBuyPrice

matchData = (data) ->
  mainColor = if data.item.name_color then '#' + data.item.name_color else '#D2D2D2'
  $('#for-edit form').attr 'action', "/listings/#{data.listing.id}"
  $('#for-edit img').attr('src', "#{data.item.icon_url}/62x62f").css('border-color', mainColor)
  $('#for-edit h3').text data.item.market_name
  $('#for-edit span.type').text data.item.type
  $('#for-edit #price').val data.listing.price / 100
  $('#for-edit #buy-price').val data.listing.buy_price / 100

managePriceAndBuyPrice = ->
  @baseFee = window.app.fee
  $("#for-edit #price").bind "keyup change", ->
    price = +$(this).val()
    if price > 0
      newBuyPrice = (price * fee(price) + 0.005).toFixed(2)
      # newBuyPrice = (+newBuyPrice + 0.01).toFixed(2) if +newBuyPrice == price
      $("#for-edit #buy-price").val newBuyPrice

  $("#for-edit #buy-price").bind "keyup change", ->
    buyPrice = +$(this).val()
    if buyPrice > 0
      newPrice = (buyPrice / fee(buyPrice) - 0.005).toFixed(2)
      # newPrice = (+newPrice - 0.01).toFixed(2) if +newPrice == buyPrice
      $("#for-edit #price").val newPrice

fee = (val) ->
  # base = switch
  #   when 0.01 <= +val < 0.02 then 0.6
  #   when 0.02 <= +val < 0.03 then 0.3
  #   when 0.03 <= +val < 0.04 then 0.25
  #   when 0.04 <= +val < 0.05 then 0.2
  #   when 0.05 <= +val < 0.06 then 0.17
  #   when 0.06 <= +val < 0.07 then 0.14
  #   when 0.07 <= +val < 0.08 then 0.12
  #   when 0.08 <= +val < 0.09 then 0.11
  #   else @baseFee

  1 + @baseFee

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
