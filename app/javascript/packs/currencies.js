import Vue from 'vue/dist/vue.esm'
import Currency from '../components/currency'

const current_currencies = JSON.parse(document.getElementById('app').getAttribute('currencies'))

document.addEventListener('DOMContentLoaded', () => {
  App.vue = new Vue({
    el: '#app',
    data: {
      currencies: current_currencies
    },
    components: {
      currency: Currency
    },
    methods: {
      refreshRates (data) {
        this.currencies = this.currencies
            .filter(elem => data.rates[elem.name])
            .map(function(index, elem) {
              return {
                name: index.name,
                rate: data.rates[index.name]['rate'],
                nomination: data.rates[index.name]['nom'],
                locale: data.locales[index.name],
              }
            })
      }
    }
  })
})
