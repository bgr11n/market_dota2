class @InventoryVM
  constructor: (items) ->
    @items = items.map (data) -> new Item data
    @selectedItem = ko.observable @items[0]
    @viewItem = (item) =>
      @selectedItem item

    ko.computed =>
      $.get "/item_price?market_hash_name=#{@selectedItem().marketHashName}", (res) =>
        @selectedItem().steamPriceInfo res

class Item
  constructor: (data={}) ->
    @item_id = data.item_id
    @classid = data.classid
    @name = data.name
    @marketHashName = data.market_hash_name
    @nameColor = data.name_color
    @iconUrl = data.icon_url
    @descriptions = data.descriptions
    @type = data.type
    @tags = data.tags
    @humanTags = @tags.map( (tag) -> tag.name ).join(', ')

    @fee = window.app.fee
    @price = ko.observable('').extend({ throttle: 150 })
    @buyPrice = ko.observable('').extend({ throttle: 150 })
    @steamPriceInfo = ko.observable {}

    @price.subscribe =>
      price = +@price()
      @updateBuyPrice price if price > 0

    @buyPrice.subscribe =>
      buyPrice = +@buyPrice()
      @updatePrice buyPrice if buyPrice > 0

    @updatePrice = (buyPrice) =>
      price = +@price()
      newBuyPrice = (price + price * @fee).toFixed(2)
      @price (buyPrice - buyPrice * @fee).toFixed(2) if buyPrice != +newBuyPrice

    @updateBuyPrice = (price) =>
      buyPrice = +@buyPrice()
      newPrice = (buyPrice - buyPrice * @fee).toFixed(2)
      @buyPrice (price + price * @fee).toFixed(2) if price != +newPrice

    @serialized = ko.computed =>
      {
        'item_id': @item_id,
        'classid': @classid,
        'name': @name,
        'market_hash_name': @marketHashName,
        'name_color': @nameColor,
        'descriptions': @descriptions,
        'type': @type,
        'icon_url': @iconUrl,
        'tags': @tags,
        'human_tags': @humanTags,
        'price': @price(),
        'buy_price': @buyPrice(),
        'steam_price_info': @steamPriceInfo()
      }

    @json = ko.computed =>
      JSON.stringify @serialized()
