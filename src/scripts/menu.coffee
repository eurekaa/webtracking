# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: menu
# Created: 13/11/13 0.09


define ['edijson', 'jquery_ui'], (edj, $)->

   # import stylesheet.
   edj.ui.load_stylesheets 'styles/menu'
   
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
         self.options.target = $(self.options.target)

         # hide menu.
         self.element.transition opacity: 0, x: -self.element.width()

         # create target container.
         container = $('<div>', { 'class': 'container' })
         self.options.target.append container
         
         # hide container
         self.options.target.transition opacity: 0, x: self.options.target.width()
      
         # retrieve user info.
         user = edj.session.get 'user'
         
         # create menu.
         self.element.empty()
         if edj.utility.to_upper(user.profile) is 'ADMIN'
            #self.element.append $('<button>', { 'rel': 'profiles', 'html': 'profili' })
            self.element.append $('<button>', { 'class': 'max_width', 'rel': 'users', 'html': 'utenti' }).button(icons: primary: 'ui-icon-person', secondary: 'ui-icon-circle-arrow-e')
         self.element.append $('<button>', { 'class': 'max_width', 'rel': 'shipments', 'html': 'spedizioni' }).button(icons: primary: 'ui-icon-suitcase', secondary: 'ui-icon-circle-arrow-e')
         
         # bind buttons click event.
         self.element.find('button').on 'click', -> self.load $(@).attr('rel')
         
         # make container responsive.
         $(window).on 'resize', ->
            height = $(window).height()
            margin_top = $('body').css('margin-top').replace 'px', ''
            margin_bottom = $('body').css('margin-bottom').replace 'px', ''
            new_height = (height - margin_top - margin_bottom) 
            self.options.target.css height: new_height + 'px'
            
            # trigger resize event on element.
            container.trigger 'resized'
      
         # show menu.
         self.element.transition opacity: 1, x: 0
         
         # show container
         self.options.target.transition { opacity: 1, x: 0 }, -> 
            
            # trigger shipments click (first app).
            self.element.find('button[rel="shipments"]').trigger 'click'
         
         # resize container the first time.
         $(window).trigger 'resize'
      
      
      _destroy: ->
         self = @
         
         # destroy menu.
         self.element.transition { opacity: 0, x: -self.element.width() }, ->
            self.element.empty()
            self.element.removeClass self.options.class
            
         # destroy container.
         self.options.target.transition { opacity: 0, x: self.options.target.width() }, ->
            self.options.target.empty()
      
      
      load: (plugin)-> 
         self = @
         
         # get container node.
         container = self.options.target.find '.container' 
         
         # unload current plugin.
         if self.options.current
            container.transition opacity: 0
            eval 'container.' + self.options.current + '("destroy");'
         
         # register new plugin.
         self.options.current = plugin
         
         # load new plugin.
         require ['scripts/' + plugin], ->
            
            # show container when plugin is ready.
            container.on 'ready', ->
               container.transition opacity: 1
               container.off 'ready'
            
            # init plugin.
            eval 'container.' + plugin + '();'