App.currency = App.cable.subscriptions.create "CurrencyChannel",
  received: (data) ->
    if document.getElementById('app')
      App.vue.refreshRates(data)
