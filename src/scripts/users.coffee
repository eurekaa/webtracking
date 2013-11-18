# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: profiles
# Created: 17/11/13 11.22


define ['edijson', 'jquery_ui', 'jquery_grid'], (edj, $)->

   # load stylesheets.
   edj.gui.load_stylesheets 'styles/libs/jquery/jquery.grid'

   $.widget 'ui.users',

      options: undefined

      _create: ->
         self = @

         # add title.
         self.element.append $('<div>', {'class': 'title', 'html': 'Gestione Utenti' })

         # add grid and pager elements.
         self.element.append $('<table>', { 'id': 'grid' })
         self.element.append $('<div>', { 'id': 'pager' })

         # create form (initially hidden).
         self.create_form()

         # setup grid.
         grid = self.element.find '#grid'
         grid.jqGrid
            datatype: "local"
            autowidth: true
            width: '100%'
            height: '100%'
            colNames: ['id', 'id_profile', 'Profilo', 'Username', 'Email', 'Nome', 'Cognome', 'Codice Cube']
            colModel: [
               { name: 'id', hidden: true }
               { name: 'id_profile', hidden: true }
               { name: 'profile' }
               { name: 'username' }
               { name: 'email' }
               { name: 'name' }
               { name: 'surname' }
               { name: 'cube_code' }
            ]
            scroll: true
            pager: '#pager'

         # setup pager.
         grid.jqGrid 'navGrid', '#pager', search: false, refresh: false, add: false, edit: false, del: false

         # setup grid buttons.
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Aggiungi', buttonicon: "ui-icon-plus", cursor: "pointer", onClickButton: -> self.insert()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Modifica', buttonicon: "ui-icon-pencil", cursor: "pointer", onClickButton: -> self.update()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Elimina', buttonicon: "ui-icon-trash", cursor: "pointer", onClickButton: -> self.delete()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Resetta', buttonicon: "ui-icon-arrowreturnthick-1-w", cursor: "pointer", onClickButton: -> self.reset_form()

         # load grid data.
         edj.database.select 'profiling.accounts', {}, (err, data)-> for item in data then grid.jqGrid 'addRowData', item.id, item

         # bind resize event.
         self.element.on 'resized', -> self.resize()
         self.resize()


      _destroy: -> @.element.empty()
      
      
      create_form: ->
         self = @
         
         # create base elements.
         form = $('<div>', { 'id': 'form' }).css display: 'none', width: '100%', height: '110px'
         input_container = $('<div>').css(width: '25%', 'padding-right': '15px', float: 'left')

         # profile.
         input = input_container.clone().empty()
         combo = $('<select>', { 'id': 'profile' }) 
         edj.gui.load_combo combo, 'profiling.profiles', 'seleziona..', 'id', 'name'
         input.append $('<label>', { 'for': 'profile', 'html': 'profilo' })
         input.append combo
         form.append input
         
         # username.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'username', 'html': 'username' })
         input.append $('<input>', { 'type': 'text', 'id': 'username' })
         form.append input

         # password.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'password', 'html': 'password' })
         input.append $('<input>', { 'type': 'password', 'id': 'password' })
         form.append input

         # password check.
         input = input_container.clone().empty().css 'padding-right': 0
         input.append $('<label>', { 'for': 'password_check', 'html': 'ridigita password' })
         input.append $('<input>', { 'type': 'password', 'id': 'password_check' })
         form.append input

         # name.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'name', 'html': 'nome' })
         input.append $('<input>', { 'type': 'text', 'id': 'name' })
         form.append input

         # surname.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'surname', 'html': 'cognome' })
         input.append $('<input>', { 'type': 'text', 'id': 'surname' })
         form.append input

         # email.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'email', 'html': 'email' })
         input.append $('<input>', { 'type': 'text', 'id': 'email' })
         form.append input

         # cube code.
         input = input_container.clone().empty().css 'width': '15%'
         input.append $('<label>', { 'for': 'cube_code', 'html': 'codice cube' })
         input.append $('<input>', { 'type': 'text', 'id': 'cube_code' })
         form.append input
         
         # submit button.
         form.append $('<button>', { 'html': 'salva' }).css(width: '9%', float: 'right', position: 'relative', top: '8px').button()
         self.element.append form
      
      
      read_form: ->
         self = @
         form = self.element.find '#form'
         data = {}
         
         # read form input values.
         data.id_profile = form.find('#profile option:selected').val()
         data.username = form.find('#username').val()
         data.password = form.find('#password').val()
         data.password_check = form.find('#password_check').val()
         data.name = form.find('#name').val()
         data.surname = form.find('#surname').val()
         data.email = form.find('#email').val()
         data.cube_code = form.find('#cube_code').val()
         
         return data
      
      
      reset_form: ->
         self = @
         self.element.find('#grid').jqGrid 'resetSelection'
         form = self.element.find '#form'
         form.find('select#profile').val ''
         form.find('input#username').val ''
         form.find('input#password').val ''
         form.find('input#password_check').val ''
         form.find('input#name').val ''
         form.find('input#surname').val ''
         form.find('input#email').val ''
         form.find('input#cube_code').val ''
         form.find('button').off 'click'
         form.hide()
         self.resize()
      
      
      validate_form: ->
         self = @
         test = true
         
         # read form values.
         form = self.read_form()
         
         # test for required fields.
         if form.profile is '' or form.username is '' or form.password is '' or form.password_check is '' or form.name is '' or 
         form.surname is '' or form.email is '' or form.cube_code is '' then return edj.gui.show_message 'Errore Utente', 'Tutti i campi sono obbligatori.'
         
         # test password matching.
         if form.password isnt form.password_check then return edj.gui.show_message 'Errore Utente', 'Le password non coincidono.'
         
         # test email validity.
         if not edj.regexp.test form.email, 'email' then return edj.gui.show_message 'Errore Utente', 'Inserire un indirizzo email valido.'
         
         # test user duplicates.
         edj.database.select 'profiling.users', { username: form.username, password: form.password }, async: false, (err, data)->
            if err then return edj.gui.show_message 'Errore di Sistema', err.message
            if data.length isnt 0 then test = false; return edj.gui.show_message 'Errore Utente', 'L\'utente che si cerca di inserire è già presenta nel sistema.' 
         
         return test
      
      
      insert: ->
         self = @
         form = self.element.find '#form'

         # handle click event.
         form.find('button').on 'click', ->
            
            # test input validity.
            if self.validate_form() isnt true then return false
            
            # read form values.
            values = self.read_form()
            
            # remove unused fields.
            delete values['password_check']
            
            # insert new user.
            edj.database.insert 'profiling.users', values, (err, data)->
               if err then return edj.gui.show_message 'Errore di Sistema', err.Message
               grid = self.element.find '#grid'
               item = data[0]
               
               # add user to grid.
               values.profile = form.find('select#profile option:selected').text()
               values.id = item.id
               grid.jqGrid 'addRowData', item.id, values
               
               # reset form.
               self.reset_form()
         
         # show form.
         form.show()
         self.resize()


      update: ->
         self = @

         # get row data if a row is selected.
         grid = self.element.find('#grid')
         row_id = grid.jqGrid 'getGridParam', 'selrow'
         if not row_id then return edj.gui.show_message 'Attenzione', 'Selezionare un elemento dalla griglia.'
         row = grid.jqGrid 'getRowData', row_id

         # admin profile can't be changed.
         if edj.utility.to_upper(row.name) is 'ADMIN' then return edj.gui.show_message 'Attenzione', 'Il profilo Admin non può essere modificato.'

         # handle click event.
         form = self.element.find '#form'
         form.find('input#name').val row.name
         form.find('button').on 'click', ->

            # test input validity.
            name = form.find('input#name').val()
            if name is '' then return edj.gui.show_message 'Errore Utente', 'Compilare il campo nome.'
            edj.database.select 'profiling.profiles', name: name, (err, data)->
               if err then return edj.gui.show_message 'Errore di Sistema', err.message
               if data.length is 1 and data[0].id is row.id or data.length > 1 then return edj.gui.show_message 'Errore Utente', 'Il profilo ' + name + ' &egrave gi&agrave presente.'

               # update profile.
               edj.database.update 'profiling.profiles', { id: row.id, name: name }, (err, data)->
                  if err then return edj.gui.show_message 'Errore di Sistema', err.message
                  grid = self.element.find '#grid'
                  item = data[0]
                  grid.jqGrid 'setRowData', row_id, { id: item.id, name: name }

                  # reset form.
                  self.reset()

         # show form.
         form.show()
         self.resize()


      delete: ->
         self = @

         # get row data if a row is selected.
         grid = self.element.find('#grid')
         row_id = grid.jqGrid 'getGridParam', 'selrow'
         if not row_id then return edj.gui.show_message 'Attenzione', 'Selezionare un elemento dalla griglia.'
         row = grid.jqGrid 'getRowData', row_id

         # admin profile can't be deleted.
         if edj.utility.to_upper(row.name) is 'ADMIN' then return edj.gui.show_message 'Attenzione', 'L\' utente Admin non può essere eliminato.'

         # delete profile.
         edj.database.delete 'profiling.users', id: row.id, (err, data)->
            if err then return edj.gui.show_message 'Errore di Sistema', err.Message
            grid.jqGrid 'delRowData', row_id


      resize: ->
         self = @
         setTimeout ->

            # calculate grid new width.
            width = self.element.outerWidth(true) -
            self.element.css('padding-left').replace('px', '') -
            self.element.css('padding-right').replace('px', '')

            # calculate grid new height.
            height = self.element.parent().height() -
            self.element.css('padding-top').replace('px', '') -
            self.element.css('padding-top').replace('px', '') -
            self.element.find('#pager').height() -
            self.element.find('.ui-jqgrid-sortable').height() -
            self.element.find('.title').outerHeight(true) -
            self.element.find('.title').css('margin-bottom').replace('px', '')

            if self.element.find('#form').is(':visible') then height -= self.element.find('#form').height()

            # resize grid.
            grid = self.element.find '#grid'
            grid.jqGrid 'setGridWidth', width
            grid.jqGrid 'setGridHeight', height

         , 100
