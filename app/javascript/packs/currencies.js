import Vue from 'vue/dist/vue.esm'
import Currency from '../components/currency'

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById("app");

  if (element != null) {
    const current_currencies = JSON.parse(element.dataset.currencies)

    App.vue = new Vue({
      el: element,
      data: function() {
        return { currencies: current_currencies }
      },
      components: {
        currency: Currency
      },
      methods: {
        refreshRates (data) {
          this.currencies = data.rates
              .map(function(index, elem) {
                return {
                  name: index.currency,
                  rate: index.rate,
                  nom: index.nom,
                  locale: index.locale,
                }
              })
        }
      }
    })
  }
})
