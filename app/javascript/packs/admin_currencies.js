import Vue from 'vue/dist/vue.esm'
import VueResource from 'vue-resource'
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(VueResource)

document.addEventListener('DOMContentLoaded', () => {
  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  const element = document.getElementById('admin')

  if (element != null) {
    const rates = JSON.parse(element.dataset.rates)

    App.admin_app = new Vue({
      el: element,
      data: {
        rates: rates
      },
      methods: {
        setRateExpired: function (data) {
          console.log(data)
          this.$http.post('/admin', { exchange_rate: data })
              .then(response => {
                console.log('response: ' + response)
              }, error => {
                console.log('error: ' + error)
              })
        }
      },
      components: {
        datetime: Datetime
      }
    })
  }
})
