process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')
const CompressionPlugin = require('compression-webpack-plugin');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

// delete default webpacker optimization plugins since we want to
// replace them entirely not append to them
environment.plugins.delete('Compression')
environment.plugins.delete('Compression Brotli')
environment.plugins.delete('OptimizeCSSAssets')

// enable asset compression using brotli
environment.plugins.prepend('Compression', new CompressionPlugin({
	filename: '[path].br[query]',
  algorithm: 'brotliCompress',
  cache: true,
	test: /\.(js|css|html|json|ico|svg|eot|otf|ttf|map)$/,
	compressionOptions: { level: 11 },
	threshold: 0,
	minRatio: 1,
	deleteOriginalAssets: false
}))

// enable advanced css minification
environment.plugins.prepend('OptimizeCssAssets', new OptimizeCssAssetsPlugin({
  cssProcessor: require('cssnano'),
  cssProcessorPluginOptions: {
    preset: ['advanced']
  },
  canPrint: false
}))

// enable js optimization and minification
environment.config.optimization = {
  minimize: true,
  minimizer: [
    new TerserPlugin({
      parallel: true,
      cache: true,
      sourceMap: false,
      terserOptions: {
        parse: { ecma: 8 },
        compress: {
          ecma: 6,
          passes: 2,
          drop_console: true,
          arguments: true,
          booleans_as_integers: true,
          keep_fargs: false,
          // enable "unsafe" optimizations - this is really only "unsafe" is your
          // JS is written poorly  making use of flawed logic and/or syntactical
          // loopholes). if that's the case, its probably best that it not work
          // anyway...
          unsafe: true,
          unsafe_arrows: true,
          unsafe_comps: true,
          unsafe_Function: true,
          unsafe_math: true,
          unsafe_symbols: true,
          unsafe_methods: true,
          unsafe_proto: true,
          unsafe_regexp: true,
          unsafe_undefined: true
        },
        output: {
          ecma: 6,
          comments: false,
          ascii_only: true,
          beautify: false
        }
      }
    })
  ]
}

module.exports = environment.toWebpackConfig()
