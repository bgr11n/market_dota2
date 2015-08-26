class @InventoryVM
  constructor: (items) ->
    @items = items.map (data) -> new Item data
    @selectedItem = ko.observable @items[0]
    @viewItem = (item) =>
      @selectedItem item

    ko.computed =>
      $.get "/item_price?market_hash_name=#{@selectedItem().marketHashName}", (res) =>
        @selectedItem().steamPriceInfo res

    @validate = =>
      @selectedItem().validate()

class Item
  constructor: (data={}) ->
    @priceCss = ko.observableArray []
    @buyPriceCss = ko.observableArray []
    @priceCssClass = ko.computed =>
      'input-group ' + @priceCss().join(' ')
    @buyPriceCssClass = ko.computed =>
      'input-group ' + @buyPriceCss().join(' ')

    @item_id = data.item_id
    @classid = data.classid
    @name = data.name
    @marketHashName = data.market_hash_name
    @marketName = data.market_name
    @nameColor = data.name_color
    @iconUrl = data.icon_url
    @descriptions = data.descriptions
    @type = data.type
    @tags = data.tags
    @humanTags = @tags.map( (tag) -> tag.name ).join(', ')

    @fee = (val) ->
      if +val <= 0.07 then 0.6 else window.app.fee
    @price = ko.observable('').extend({ throttle: 150 })
    @buyPrice = ko.observable('').extend({ throttle: 150 })
    @steamPriceInfo = ko.observable {}

    @errors = ko.observableArray []

    @price.subscribe =>
      price = +@price()
      @updateBuyPrice price if price > 0

    @buyPrice.subscribe =>
      buyPrice = +@buyPrice()
      @updatePrice buyPrice if buyPrice > 0

    @updatePrice = (buyPrice) =>
      price = +@price()
      newPrice = (buyPrice - buyPrice * @fee(buyPrice)).toFixed(2)
      newBuyPrice = (price + price * @fee(buyPrice)).toFixed(2)
      @price newPrice if buyPrice != +newBuyPrice

    @updateBuyPrice = (price) =>
      buyPrice = +@buyPrice()
      newPrice = (buyPrice - buyPrice * @fee(price)).toFixed(2)
      newBuyPrice = (price + price * @fee(price)).toFixed(2)
      @buyPrice newBuyPrice if price != +newPrice

    @validate = =>
      @errors []
      @priceCss []
      @buyPriceCss []
      @priceCss.push 'has-error' unless +@price() > 0
      @buyPriceCss.push 'has-error' unless +@buyPrice() > 0
      unless +@price() > 0 and +@buyPrice() > 0
        @errors.push 'Необходимо указать действительную цену.'
        return false
      true

    @serialized = ko.computed =>
      {
        'item_id': @item_id,
        'classid': @classid,
        'name': @name,
        'market_hash_name': @marketHashName,
        'market_name': @marketName,
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
