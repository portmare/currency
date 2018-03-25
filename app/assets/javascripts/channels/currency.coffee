App.currency = App.cable.subscriptions.create "CurrencyChannel",
  received: (data) ->
    App.vue.refreshRates(data)
