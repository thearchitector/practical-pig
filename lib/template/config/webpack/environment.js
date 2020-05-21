const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

// ensure that we expose global variables
// environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
// 	$: 'jquery',
// 	jQuery: 'jquery',
// }))

// disable source map emission
environment.config.merge({ devtool: 'none' })

module.exports = environment