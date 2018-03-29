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
        rates: rates,
        errors: [],
        notice: ''
      },
      methods: {
        setRateExpired: function (data) {
          this.$http.post('/admin', { exchange_rate: data })
              .then(response => {
                this.errors = []
                const rate = response.body.rate
                const options = {
                  day: 'numeric',
                  month: 'long',
                  year: 'numeric',
                  hour: 'numeric',
                  minute: 'numeric',
                  second: 'numeric'
                }
                const expired_at = new Date(rate.expired_at).toLocaleString('ru', options)
                this.notice = `Форсированный курс для ${rate.currency.toUpperCase()} в значение ${rate.rate} успешно установлен до ${expired_at}!`
              }, response => {
                this.notice = ''
                this.errors = response.body.errors
              })
        },
        rateValid: function (data) {
          if (data <= 0 || data === '' || data == null) {
            return 'text-danger is-invalid'
          }
        },
        dateValid: function (data) {
          if (data === '' || data == null) {
            return 'text-danger is-invalid'
          }
        }
      },
      components: {
        datetime: Datetime
      }
    })
  }
})
