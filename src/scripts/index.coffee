# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 11/11/13 20.24


# requirejs configuration.
require.config
   baseUrl: '.'
   urlArgs: 'v=' + (new Date()).getTime()
   paths:
      edijson: 'scripts/libs/edijson/index'
      domready: 'scripts/libs/utility/require.domready'
      underscore: 'scripts/libs/utility/underscore'
      jquery: 'scripts/libs/jquery/jquery'
      jquery_private: 'scripts/libs/jquery/jquery.private'
      jquery_ui: 'scripts/libs/jquery/jquery.ui' 
      jquery_easing: 'scripts/libs/jquery/jquery.easing'
      jquery_animate: 'scripts/libs/jquery/jquery.animate'
      jquery_slider: 'scripts/libs/jquery/jquery.slider'
      jquery_touchswipe: 'scripts/libs/jquery/jquery.touchswipe'
      jquery_tooltip: 'scripts/libs/jquery/jquery.tooltip'
      jquery_images_loaded: 'scripts/libs/jquery/jquery.images_loaded'
      jquery_grid: 'scripts/libs/jquery/jquery.grid'
      jquery_grid_it: 'scripts/libs/jquery/jquery.grid.locale-it'
   
   shim: # used to setup modules dependencies.
      jquery_ui: deps: ['jquery', 'jquery_easing', 'jquery_animate'], exports: '$'
      jquery_easing: deps: ['jquery']
      jquery_animate: deps: ['jquery']
      jquery_touchswipe: deps: ['jquery']
      jquery_slider: deps: ['jquery_ui', 'jquery_touchswipe']
      jquery_grid: deps: ['jquery_ui', 'jquery_grid_it']
      jquery_tooltip: ['jquery', 'jquery_images_loaded']
   
   map:
      jquery_private:
         jquery: 'jquery'
         '*': jquery: 'scripts/libs/jquery/jquery.private'


# requirejs error handling.
require.onError = (err)-> console.error err

# init index.
require ['domready', 'edijson', 'jquery_ui', 
   'scripts/user', 'scripts/menu'
], (domready, edj, $)->
   
   domready ->
      # load stylesheets.
      edj.gui.load_stylesheets [
         'styles/index'
         'styles/libs/fonts'
         'styles/libs/animate'
         'styles/libs/jquery/darkness/jquery.ui'
      ]
      
      $('#user').user
         login: -> $('#menu').menu target: '#panel'
         logout: -> $('#menu').menu 'destroy'
