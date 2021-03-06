const { environment } = require('@rails/webpacker')

const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default'],
    Rails: ['@rails/ujs']
  }))
  
environment.config.set('resolve.alias', {jquery: 'jquery/src/jquery'});

module.exports = environment
