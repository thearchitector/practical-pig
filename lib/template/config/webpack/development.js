process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const webpack = require('webpack')

// enable automatic prefetching to speed incremental built times
environment.plugins.prepend('AutomaticPrefetch', new webpack.AutomaticPrefetchPlugin())

module.exports = environment.toWebpackConfig()