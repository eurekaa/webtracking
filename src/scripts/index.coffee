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
   #urlArgs: 'v=' + (new Date()).getTime()
   paths:
      edijson: 'scripts/libs/edijson/index'
      domready: 'scripts/libs/utility/require.domready'
      order: 'scripts/libs/utility/require.order'
      underscore: 'scripts/libs/utility/underscore'
      moment: 'scripts/libs/utility/moment'
      jquery: 'scripts/libs/jquery/jquery'
      jquery_private: 'scripts/libs/jquery/jquery.private'
      jquery_ui: 'scripts/libs/jquery/jquery.ui' 
      jquery_easing: 'scripts/libs/jquery/jquery.easing'
      jquery_animate: 'scripts/libs/jquery/jquery.animate'
      jquery_transit: 'scripts/libs/jquery/jquery.transit'
      jquery_slider: 'scripts/libs/jquery/jquery.slider'
      jquery_touchswipe: 'scripts/libs/jquery/jquery.touchswipe'
      jquery_tooltip: 'scripts/libs/jquery/jquery.tooltip'
      jquery_images_loaded: 'scripts/libs/jquery/jquery.images_loaded'
      jquery_grid: 'scripts/libs/jquery/jquery.grid'
      jquery_grid_it: 'scripts/libs/jquery/jquery.grid.locale-it'
      jquery_datepicker_it: 'scripts/libs/jquery/jquery.ui.datepicker-it'
   
   shim: # used to setup modules dependencies.
      jquery_ui: deps: ['jquery', 'jquery_easing', 'jquery_animate', 'jquery_transit'], exports: '$'
      jquery_easing: deps: ['jquery']
      jquery_animate: deps: ['jquery']
      jquery_transit: deps: ['jquery']
      jquery_datepicker_it: deps: ['jquery_ui']
      jquery_touchswipe: deps: ['jquery']
      jquery_slider: deps: ['jquery_ui', 'jquery_touchswipe']
      jquery_grid: deps: ['jquery_ui', 'jquery_grid_it']
      jquery_tooltip: deps: ['jquery', 'jquery_images_loaded']


# requirejs error handling.
require.onError = (err)-> console.error err

# init index.
require ['domready!', 'edijson', 'jquery_ui', 'jquery_datepicker_it', 'scripts/user', 'scripts/menu'], (dom, edj, $)->
   
   # load stylesheets.
   edj.ui.load_stylesheets [
      'styles/index'
      #'styles/libs/fonts'
      'styles/libs/animate'
      'styles/libs/jquery/darkness/jquery.ui'
   ]
   
   # jquery animations fallback.
   if not $.support.transition then $.fn.transition = $.fn.animate
   
   # setup datepicker language for all application.
   $.datepicker.setDefaults $.datepicker.regional['it']
   
   # start user login
   $('#user').user
      login: -> $('#menu').menu target: '#panel'
      logout: -> $('#menu').menu 'destroy'
