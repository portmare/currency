const { environment } = require('@rails/webpacker')

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
});

const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)
module.exports = environment
