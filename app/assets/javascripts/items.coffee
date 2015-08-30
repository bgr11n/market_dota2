$(document).on 'ready page:load', ->
  $('.edit-listing-btn').on 'click', (e) ->
    btn = $(this)
    $.get "/listings/#{btn.data('lid')}", (data) ->
      matchData data

matchData = (data) ->
  $('#for-edit img').attr('src', "#{data.item.icon_url}/62x62f").css('border-color', if data.item.name_color then '#' + data.item.name_color else '#D2D2D2' )
  $('#for-edit h3').text data.item.market_name
  $('#for-edit span.type').text data.item.type
  $('#for-edit #price').val data.listing.price / 100
  $('#for-edit #buy-price').val data.listing.buy_price / 100
  turbolinks.visit '/'
