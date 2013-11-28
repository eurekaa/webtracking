# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: login
# Created: 12/11/13 23.03


define ['edijson', 'jquery_ui'], (edj, $)->
   
   # import stylesheet.
   edj.ui.load_stylesheets 'styles/user'
   
   # define widget.
   $.widget 'ui.user',
      
      options: undefined
      
      
      _create: ()->
         self = @
         
         # show login if no user is logged, welcome otherwise.
         if self.is_logged() then self.show_welcome -> self._trigger 'login'
         else self.show_login()
      
      
      show_login: ()->
         self = @
         
         # hide welcome box.
         self.element.transition opacity: 0, x: -self.element.width(), ->
            self.element.empty()
            
            # create login form.
            self.element.append $('<div>', { 'class': 'title', 'html': 'Login:' })
            self.element.append $('<label>', { 'for': 'username', 'html': 'username' })
            self.element.append $('<input>', { 'type': 'text', 'id': 'username' })
            self.element.append $('<label>', { 'for': 'password', 'html': 'password' })
            self.element.append $('<input>', { 'type': 'password', 'id': 'password' })
            self.element.append $('<div>').css 'border-bottom': '1px solid #B4B4B4', 'padding-top': '20px', 'margin-bottom': '10px'
            self.element.append $('<button>', { 'class': 'max_width', 'html': 'login' }).button(icons: primary: 'ui-icon-circle-check', secondary: 'ui-icon-circle-arrow-e').click(-> self.login ->)
            
            # show login form.
            self.element.transition opacity: 1, x: 0
      
      
      show_welcome: (callback)->
         self = @
         
         user = self.get_user()
      
         # hide login form.
         self.element.transition opacity: 0, x: -self.element.width(), ->
            self.element.empty()
            
            # add user info.
            self.element.append $('<div>', { 'class': 'title', 'html': 'Benvenuto!' })
            self.element.append $('<div>', { 'class': 'info', 'html': 'UTENTE: ' + edj.utility.capitalize(user['name']) + ' ' + edj.utility.capitalize(user['surname']) })
            self.element.append $('<div>', { 'class': 'info', 'html': 'PROFILO: ' + edj.utility.capitalize(user['profile']) })
            self.element.append $('<div>').css 'border-bottom': '1px solid #B4B4B4', 'padding-top': '10px', 'margin-bottom': '10px'
            
            # add logout button.
            self.element.append $('<button>', { 'class': 'max_width', 'html': 'logout'}).button(icons: primary: 'ui-icon-power', secondary: 'ui-icon-circle-arrow-e').click(-> self.logout ->)
            
            # show welcome box.
            self.element.transition opacity: 1, x: 0
            
            # callback.
            if callback then callback null
      
      
      is_logged: ->
         user = @.get_user() 
         return edj.utility.is_defined(user) and user isnt null 
      
      
      get_user: -> edj.session.get 'user'
      
      
      login: ()->
         self = @
         
         # read login form.
         username = self.element.find('#username').val()
         password = self.element.find('#password').val()
         if username is '' or password is '' then return edj.ui.show_message 'Errore Utente', 'per accedere al sistema compilare i campi username e password.'
         
         # test account validity.
         edj.database.select 'profiling.accounts', { username: username, password: password }, (err, data)->
            
            # handle errors.
            if err then return edj.ui.show_message 'Errore di Sistema', err['Message']
            if data.length is 0 then return edj.ui.show_message 'Errore Login', 'username e password non corrispondono ad un account valido.'
            
            # store user in session.
            edj.session.set 'user', data[0]
            
            # show welcome.
            self.show_welcome ->
         
               # trigger login event.
               self._trigger 'login'
      
      
      logout: ->
         self = @
         
         # remove user from session.
         edj.session.remove 'user'
         
         # show login form.
         self.show_login()

         # trigger logout event.
         self._trigger 'logout'
