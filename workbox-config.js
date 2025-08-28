module.exports = {
	globDirectory: 'scripts/',
	globPatterns: [
		'**/*.js'
	],
	swDest: 'scripts/sw.js',
	ignoreURLParametersMatching: [
		/^utm_/,
		/^fbclid$/,
		/^EOF/
	]
};