# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: menu
# Created: 13/11/13 0.09


define ['edijson', 'jquery_ui'], (edj, $)->

   # import stylesheet.
   edj.gui.load_stylesheets 'styles/menu'
   
   # define widget.
   $.widget 'ui.menu',
      
      options: 
         class: 'menu'
         target: undefined
         current: undefined
      
      
      _create: ->
         self = @

         # add element class.
         self.element.addClass self.options.class
      
         # retrieve user info.
         user = edj.session.get 'user'
         
         # create menu.
         self.element.empty()
         if edj.utility.to_upper(user.profile) is 'ADMIN'
            self.element.append $('<button>', { 'rel': 'profiles', 'html': 'profili' })
            self.element.append $('<button>', { 'rel': 'users', 'html': 'utenti' })
         self.element.append $('<button>', { 'rel': 'shipments', 'html': 'spedizioni' })
         
         # bind buttons click event.
         self.element.find('button').button().click( ->
            self.load $(@).attr('rel')
         )
         
         # create target container.
         self.options.target = $(self.options.target)
         container = $('<div>', { 'class': 'container' })
         self.options.target.append container
         
         # make container responsive.
         $(window).on 'resize', ->
            height = $(window).height()
            margin_top = $('body').css('margin-top').replace 'px', ''
            margin_bottom = $('body').css('margin-bottom').replace 'px', ''
            new_height = (height - margin_top - margin_bottom) 
            self.options.target.css height: new_height + 'px'
            
            # trigger resize event on element.
            container.trigger 'resized'

         # resize container the first time.
         $(window).trigger 'resize'
      
         # show menu.
         self.element.animate_css 'bounceInLeft'
            
         # show container
         self.options.target.animate_css 'bounceInRight'
      
      
      _destroy: ->
         self = @
         
         # destroy menu.
         self.element.animate_css 'bounceOutLeft', ->
            self.element.empty()
            self.element.removeClass self.options.class
            
         # destroy container.
         self.options.target.animate_css 'bounceOutRight', ->
            self.options.target.css display: 'none'
            self.options.target.empty()
      
      
      load: (plugin)-> 
         self = @
         
         # get container node.
         container = self.options.target.find '.container'
         
         # unload current plugin.
         if self.options.current
            container.animate_css 'bounceOutDown'
            eval 'container.' + self.options.current + '("destroy");'
            container.css visibility: 'hidden'
         
         # register new plugin.
         self.options.current = plugin
         
         # load, run and show new plugin.
         require ['scripts/' + plugin], ->
            eval 'container.' + plugin + '();'
            container.animate_css 'bounceInDown'
