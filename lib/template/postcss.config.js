module.exports = {
	plugins: [
		require('postcss-import'),
		require('postcss-flexbugs-fixes'),
		require('autoprefixer'),
    require('postcss-fail-on-warn')
	]
}