# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: profiles
# Created: 17/11/13 11.22


define ['edijson', 'jquery_ui', 'jquery_grid'], (edj, $)->
   
   # load stylesheets.
   edj.ui.load_stylesheets 'styles/libs/jquery/jquery.grid'
   
   $.widget 'ui.profiles',
      
      options: undefined
      
      _create: ->
         self = @
         
         # add title.
         self.element.append $('<div>', {'class': 'title', 'html': 'Gestione Profili' })
         
         # add grid and pager elements.
         self.element.append $('<table>', { 'id': 'grid' })
         self.element.append $('<div>', { 'id': 'pager' })
         
         # create form (initially hidden).
         form = $('<div>', { 'id': 'form' }).css display: 'none', width: '100%', height: '50px'
         input = $('<div>').css(width: '90%', 'padding-right': '15px', float: 'left')
         input.append $('<label>', { 'for': 'name', 'html': 'nome' })
         input.append $('<input>', { 'type': 'text', 'id': 'name' })
         form.append input
         form.append $('<button>', { 'html': 'salva' }).css(width: '9%', float: 'right', position: 'relative', top: '8px').button()
         self.element.append form

         # setup grid.
         grid = self.element.find '#grid'
         grid.jqGrid
            datatype: "local" 
            autowidth: true
            width: '100%'
            height: '100%' 
            colNames: ['id', 'Profilo']
            colModel: [
               { name: 'id', hidden: true }
               { name: 'name' }
            ]
            scroll: true
            pager: '#pager' 
         
         # setup pager.
         grid.jqGrid 'navGrid', '#pager', search: false, refresh: false, add: false, edit: false, del: false 
         
         # setup grid buttons.
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Aggiungi', buttonicon: "ui-icon-plus", cursor: "pointer", onClickButton: -> self.insert()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Modifica', buttonicon: "ui-icon-pencil", cursor: "pointer", onClickButton: -> self.update()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Elimina', buttonicon: "ui-icon-trash", cursor: "pointer", onClickButton: -> self.delete()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Resetta', buttonicon: "ui-icon-arrowreturnthick-1-w", cursor: "pointer", onClickButton: -> self.reset() 
         
         # load grid data.
         edj.database.select 'profiling.profiles', {}, (err, data)-> for item in data then grid.jqGrid 'addRowData', item.id, item
         
         # bind resize event.
         self.element.on 'resized', -> self.resize()
         self.resize()
      
      
      _destroy: -> @.element.empty()
      
      
      reset: ->
         self = @
         self.element.find('#grid').jqGrid 'resetSelection'
         form = self.element.find '#form'
         form.find('input#name').val ''
         form.find('button').off 'click'
         form.hide()
         self.resize()
      
      
      insert: ->
         self = @
         form = self.element.find '#form'
         
         # handle click event.
         form.find('button').on 'click', ->
            
            # test input validity.
            name = form.find('input#name').val()
            if name is '' then return edj.ui.show_message 'Errore Utente', 'Compilare il campo nome.'
            edj.database.select 'profiling.profiles', name: name, (err, data)->
               if err then return edj.ui.show_message 'Errore di Sistema', err.message
               if data.length > 0 then return edj.ui.show_message 'Errore Utente', 'Il profilo ' + name + ' &egrave gi&agrave presente.'
               
               # insert new item.
               edj.database.insert 'profiling.profiles', name: name, (err, data)->
                  if err then return edj.ui.show_message 'Errore di Sistema', err.message
                  grid = self.element.find '#grid'
                  item = data[0]
                  grid.jqGrid 'addRowData', item.id, { id: item.id, name: name }
                  
                  # reset form.
                  self.reset()
         
         # show form.
         form.show()
         self.resize()
      
      
      update: ->
         self = @
      
         # get row data if a row is selected.
         grid = self.element.find('#grid')
         row_id = grid.jqGrid 'getGridParam', 'selrow'
         if not row_id then return edj.ui.show_message 'Attenzione', 'Selezionare un elemento dalla griglia.'
         row = grid.jqGrid 'getRowData', row_id
         
         # admin profile can't be changed.
         if edj.utility.to_upper(row.name) is 'ADMIN' then return edj.ui.show_message 'Attenzione', 'Il profilo Admin non può essere modificato.'
         
         # handle click event.
         form = self.element.find '#form'
         form.find('input#name').val row.name
         form.find('button').on 'click', ->
            
            # test input validity.
            name = form.find('input#name').val()
            if name is '' then return edj.ui.show_message 'Errore Utente', 'Compilare il campo nome.'
            edj.database.select 'profiling.profiles', name: name, (err, data)->
               if err then return edj.ui.show_message 'Errore di Sistema', err.message
               if data.length is 1 and data[0].id is row.id or data.length > 1 then return edj.ui.show_message 'Errore Utente', 'Il profilo ' + name + ' &egrave gi&agrave presente.'
               
               # update profile.
               edj.database.update 'profiling.profiles', { id: row.id, name: name }, (err, data)->
                  if err then return edj.ui.show_message 'Errore di Sistema', err.message
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
         if not row_id then return edj.ui.show_message 'Attenzione', 'Selezionare un elemento dalla griglia.'
         row = grid.jqGrid 'getRowData', row_id
         
         # admin profile can't be deleted.
         if edj.utility.to_upper(row.name) is 'ADMIN' then return edj.ui.show_message 'Attenzione', 'Il profilo Admin non può essere eliminato.'
         
         # profile can't be deleted if there are users associated with it.
         edj.database.select 'profiling.users', id_profile: row.id, (err, data)->
            if err then return edj.ui.show_message 'Errore di Sistema', err.message
            if data.length > 0 then return edj.ui.show_message 'Errore Utente', 'Il profilo ' + row.name + ' è associato a ' + data.length + ' utenti, pertanto non può essere eliminato.'
         
         # delete profile.
         edj.database.delete 'profiling.profiles', id: row.id, (err, data)->
            if err then return edj.ui.show_message 'Errore di Sistema', err.message
            grid.jqGrid 'delRowData', row_id
      
      
      resize: ->
         self = @
         setTimeout ->
            
            # calculate grid new width.
            width = self.element.outerWidth(true) - 
               self.element.css('padding-left').replace('px','') - 
               self.element.css('padding-right').replace('px','')
            
            # calculate grid new height.
            height = self.element.parent().height() - 
               self.element.css('padding-top').replace('px','') - 
               self.element.css('padding-top').replace('px','') -
               self.element.find('#pager').height() -
               self.element.find('.ui-jqgrid-sortable').height() -
               self.element.find('.title').outerHeight(true) - 
               self.element.find('.title').css('margin-bottom').replace('px','')
               
            if self.element.find('#form').is(':visible') then height -= self.element.find('#form').height()

            # resize grid.
            grid = self.element.find '#grid'
            grid.jqGrid 'setGridWidth', width
            grid.jqGrid 'setGridHeight', height
            
         , 100
