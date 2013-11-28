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
   
   $.widget 'ui.shipments',
      
      
      options: 
         today: undefined
      
      
      _create: ->
         self = @
         
         # retrieve server date.
         edj.api.call 'time.now', {}, (err, now)->
            if err then return edj.ui.show_message 'Errore di Sistema', err['Message']
            self.options.today = self.format_iso_date now
         
            # add title.
            self.element.append $('<div>', {'class': 'title', 'html': 'Tracking Spedizioni' })
            
            # create grid.
            self.create_grid()
            
            # create form (initially hidden).
            self.create_form()
   
            # create search (initially hidden).
            self.create_search()
   
            # load grid data.
            self.load_grid()
            
            # bind resize event.
            self.element.on 'resized', -> self.resize()
            
            #  resize the first time.
            self.resize()
      
      
      _destroy: -> @.element.empty()
      
      
      create_grid: ->
         self = @
      
         # add grid and pager elements.
         self.element.append $('<table>', { 'id': 'grid' })
         self.element.append $('<div>', { 'id': 'pager' })
         
         # retrieve user (different profiles may see different fields).
         user = edj.session.get 'user'
         
         # prepare models for grid columns.
         col_model = []; col_names = []
      
         # shipments fields.
         col_model.push { name: 'id', hidden: true }; col_names.push 'Id'
         col_model.push { name: 'insert_date', hidden: true }; col_names.push 'Data Inserimento'
         col_model.push { name: 'update_date', hidden: true }; col_names.push 'Data Aggiornamento'
         col_model.push { name: 'shipment_key', hidden: true }; col_names.push 'Codice'
         col_model.push { name: 'shipment_date', width: 70, sorttype: 'date', formatter: self.format_iso_date }; col_names.push 'Data Sped.'
         
         # courier fields.
         col_model.push { name: 'courier_code', hidden: true }; col_names.push 'Cod Corr.'
         
         # customer fields.
         if edj.utility.to_upper(user.profile) is 'ADMIN'
            col_model.push { name: 'customer_code', hidden: true }; col_names.push 'Cod. Cli.'
            col_model.push { name: 'customer_business_name' }; col_names.push 'Cliente'
            col_model.push { name: 'customer_city', hidden: true }; col_names.push 'Città Cli.'
            col_model.push { name: 'customer_country', hidden: true }; col_names.push 'Prov. Cli.'
         
         # sender fields.
         col_model.push { name: 'sender_reference', width: 80 }; col_names.push 'Rif. Mitt.'
         
         if edj.utility.to_upper(user.profile) is 'DESTINATARIO' or 
         edj.utility.to_upper(user.profile) is 'CORRISPONDENTE' or
         edj.utility.to_upper(user.profile) is 'ADMIN'
            col_model.push { name: 'sender_code', hidden: true }; col_names.push 'Cod. Mitt.'
            col_model.push { name: 'sender_business_name' }; col_names.push 'Mittente'
            col_model.push { name: 'sender_city', hidden: true }; col_names.push 'Città Mitt.'
            col_model.push { name: 'sender_country', hidden: true }; col_names.push 'Nazione Mitt.'
         
         # consignee fields.
         if edj.utility.to_upper(user.profile) is 'MITTENTE' or 
         edj.utility.to_upper(user.profile) is 'CORRISPONDENTE' or
         edj.utility.to_upper(user.profile) is 'CLIENTE' or
         edj.utility.to_upper(user.profile) is 'ADMIN'
            col_model.push { name: 'consignee_code', hidden: true }; col_names.push 'Cod. Dest.'
            col_model.push { name: 'consignee_business_name' }; col_names.push 'Destinatario'
            col_model.push { name: 'consignee_city', hidden: true }; col_names.push 'Città Dest.'
            col_model.push { name: 'consignee_country', hidden: true }; col_names.push 'Nazione Dest.'
         
         # common fields.
         col_model.push { name: 'shipment_weigth', width: 50, sorttype: 'float' }; col_names.push 'Peso'
         col_model.push { name: 'shipment_package', width: 50, sorttype: 'integer' }; col_names.push 'Colli'
         col_model.push { name: 'shipment_volume', width: 50, sorttype: 'float' }; col_names.push 'Volume'
         col_model.push { name: 'result_date', width: 70, sorttype: 'date', formatter: self.format_iso_date }; col_names.push 'Data Esito'
         col_model.push { name: 'result_type', width: 80 }; col_names.push 'Tipo Esito'
         
         # setup grid.
         grid = self.element.find '#grid'
         grid.jqGrid
            datatype: "local"
            autowidth: true
            colModel: col_model
            colNames: col_names
            gridview: true
            viewrecords: true
            forceFit: true
            scroll: true
            pager: '#pager'
         
         # setup pager.
         grid.jqGrid 'navGrid', '#pager', search: false, refresh: false, add: false, edit: false, del: false
         
         # add grid buttons.
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Resetta', buttonicon: "ui-icon-arrowreturnthick-1-w", cursor: "pointer", onClickButton: -> self.reset()
         grid.jqGrid 'navButtonAdd', '#pager', caption: 'Cerca', buttonicon: "ui-icon-search", cursor: "pointer", onClickButton: -> self.search()
         
         # only admin and courier can result a shipment.
         if edj.utility.to_upper(user.profile) is 'ADMIN' or edj.utility.to_upper(user.profile) is 'CORRISPONDENTE' 
            grid.jqGrid 'navButtonAdd', '#pager', caption: 'Esita', buttonicon: "ui-icon-flag", cursor: "pointer", onClickButton: -> self.result()
         
         # trigger ready event.
         self.element.trigger 'ready'
      
      load_grid: ->
         self = @
         
         # retrieve user info.
         user = edj.session.get 'user' 
         
         # reset grid.
         grid = self.element.find '#grid'
         grid.jqGrid 'clearGridData'
         
         # show progress
         edj.ui.show_progress 'Caricamento..', 'Attendere il caricamento delle spedizioni.', my: "center", at: "center", of: '#right'
         
         # read procedure paramenters from search values.
         search = self.element.find '#search'
         shipment_date_from = search.find('#shipment_date_from').val()
         shipment_date_to = search.find('#shipment_date_to').val()
         sender_reference = search.find('#sender_reference').val()
         sender_business_name = search.find('#sender_business_name').val()
         consignee_business_name = search.find('#consignee_business_name').val()
         
         parameters =
            shipment_date_from: if shipment_date_from isnt '' then edj.date.to_iso(shipment_date_from) else undefined
            shipment_date_to: if shipment_date_to isnt '' then edj.date.to_iso(shipment_date_to) else undefined
            sender_reference: if sender_reference isnt '' then sender_reference else undefined
            sender_business_name: if sender_business_name isnt '' then sender_business_name else undefined
            consignee_business_name: if consignee_business_name isnt '' then consignee_business_name else undefined

         # if user is a courier force filter on user cube code.
         if edj.utility.to_upper(user.profile) is 'CORRISPONDENTE'
            parameters.courier_code = user.cube_code
         
         # if user is a consignee force filter on user cube code.
         if edj.utility.to_upper(user.profile) is 'DESTINATARIO'
            delete parameters.consignee_business_name 
            parameters.consignee_code = user.cube_code
         
         # if user is a sender force filter on user cube code.
         if edj.utility.to_upper(user.profile) is 'MITTENTE'
            delete parameters.sender_business_name
            parameters.sender_code = user.cube_code
         
         # execute stored procedure.
         edj.database.procedure 'tracking.shipments_search', parameters, (err, data)->
            if err then return edj.ui.show_message 'Errore di Sistema', err['Message']

            # load grid data (for big data set grid param 'data', otherwise addRowData method (which solves a bug in visualizzation).
            if data.length < 50 then for item in data then grid.jqGrid 'addRowData', item.id, item
            else grid.setGridParam({ data: data, rowNum: data.length }).trigger 'reloadGrid'
            
            # resize page.
            self.resize() 
            
            # hide progress
            edj.ui.hide_progress()
      
      
      create_search: ->
         self = @
      
         search = $('<div>', { 'id': 'search' }).css display: 'none', width: '100%', height: '50px'
         input_container = $('<div>').css(width: '18%', 'padding-right': '15px', float: 'left')
         
         # date from.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'shipment_date_from', 'html': 'Data Da' })
         input.append $('<input>', { 'type': 'text', 'id': 'shipment_date_from', value: self.options.today }).datepicker()
         search.append input

         # date to.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'shipment_date_to', 'html': 'Data A' })
         input.append $('<input>', { 'type': 'text', 'id': 'shipment_date_to', value: self.options.today }).datepicker()
         search.append input

         # sender reference.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'sender_reference', 'html': 'Rif. Mitt.' })
         input.append $('<input>', { 'type': 'text', 'id': 'sender_reference' })
         search.append input

         # sender business name.
         input = input_container.clone().empty()
         input.append $('<label>', { 'for': 'sender_business_name', 'html': 'Mittente' })
         input.append $('<input>', { 'type': 'text', 'id': 'sender_business_name' })
         search.append input

         # consignee business name.
         input = input_container.clone().empty() #.css 'padding-right': 0
         input.append $('<label>', { 'for': 'consignee_business_name', 'html': 'Destinatario' })
         input.append $('<input>', { 'type': 'text', 'id': 'consignee_business_name' })
         search.append input
         
         # submit button.
         search.append $('<button>', { 'html': 'cerca' }).css(width: '9%', float: 'right', position: 'relative', top: '8px').button()
         self.element.append search
   
      
      create_form: ->
         self = @
         form = $('<div>', { 'id': 'form' }).css display: 'none', width: '100%', height: '50px'
         
         # result date.
         input = $('<div>').css(width: '35%', 'padding-right': '15px', float: 'left')
         input.append $('<label>', { 'for': 'result_date', 'html': 'Data Esito' })
         input.append $('<input>', { 'type': 'text', 'id': 'result_date' }).datepicker()
         form.append input
         
         # result type.
         input = $('<div>').css(width: '55%', 'padding-right': '15px', float: 'left')
         input.append $('<label>', { 'for': 'result_type', 'html': 'Tipo Esito' })
         select = $('<select>', { 'id': 'result_type' })
         select.append $('<option>', { 'value': '', 'text': 'seleziona..' })
         select.append $('<option>', { 'value': 'consegnata', 'text': 'consegnata' })
         select.append $('<option>', { 'value': 'giacenza', 'text': 'giacenza' })
         select.append $('<option>', { 'value': 'danno', 'text': 'danno' })
         input.append select
         form.append input
         
         form.append $('<button>', { 'html': 'salva' }).css(width: '9%', float: 'right', position: 'relative', top: '8px').button()
         self.element.append form
      
      
      search: -> 
         self = @
         
         # hide result form if shown.
         form = self.element.find '#form' 
         if form.is ':visible'
            form.hide()
            self.resize()
         
         # show search form.
         search = self.element.find '#search'
         button = search.find 'button'
         button.on 'click', -> self.load_grid()
         search.show()
         self.resize()
      
      
      result: -> 
         self = @
         
         # retrieve grid and selected row.
         grid = self.element.find '#grid'
         row_id = grid.jqGrid 'getGridParam', 'selrow'

         # check if a row is selected.
         if not row_id then return edj.ui.show_message 'Attenzione', 'Selezionare un elemento dalla griglia.'

         # shipments can be resulted only once.
         row = grid.jqGrid 'getRowData', row_id
         if edj.date.is_valid row.result_date then return edj.ui.show_message 'Attenzione', 'La spedizione è già stata esitata.'

         # hide search form if shown.
         search = self.element.find '#search'
         if search.is ':visible'
            search.hide()
            search.resize()
         
         # handle button click event.
         form = self.element.find '#form'
         button = form.find 'button'
         button.on 'click', ->
            
            # test form.
            result_date = form.find('#result_date').val()
            result_type = form.find('#result_type option:selected').val()
            if result_date is '' or result_type is '' then return edj.ui.show_message 'Errore Utente', 'Compilare tutti i campi.'
            
            # ask for confirmation.
            edj.ui.show_message 'Attenzione', 'Una volta esistata la spedizione non potrà più essere modificata, si desidera proseguire?', [
               { text: 'No', click: -> 
                  $(@).dialog 'close'; $(@).dialog 'destroy'; $(@).empty() 
               },
               { text: 'Si', click: ->
                  
                  dialog = @
                  
                  # retrieve server datetime.
                  edj.api.call 'time.now', {}, (err, now)->
                     if err then return edj.ui.show_message 'Errore di Sistema', err['Message']
                     now = edj.date.from_iso now
                     # save to database.
                     row.shipment_date = edj.date.to_iso row.shipment_date
                     row.update_date = edj.date.to_iso now
                     row.result_date = edj.date.to_iso result_date
                     row.result_type = result_type
                     edj.database.update 'tracking.shipments', row, (err, data)->
                        if err then return edj.ui.show_message 'Errore di Sistema', err['Message']
                        
                        # update grid.
                        row.shipment_date = edj.date.format edj.date.from_iso(row.shipment_date), 'DD/MM/YYYY'
                        row.update_date = now
                        row.result_date = result_date
                        row.result_type = result_type
                        grid.jqGrid 'setRowData', parseInt(row_id, 10), row
                        
                        # reset form.
                        self.reset()
                        
                        # close dialog.
                        $(dialog).dialog 'close'; $(dialog).dialog 'destroy'; $(dialog).empty()
               }]
         
         # show form.
         form.show()
         self.resize()
      
      
      reset: ->
         self = @
         
         # reset result form.
         form = self.element.find '#form'
         form.find('#result_date').val ''
         form.find('#result_type').val ''
         form.find('button').off 'click'
         form.hide()

         # reset search form.
         search = self.element.find '#search'
         search.find('#shipment_date_from').val self.options.today
         search.find('#shipment_date_to').val self.options.today
         search.find('#sender_reference').val ''
         search.find('#sender_business_name').val ''
         search.find('#consignee_business_name').val ''
         search.find('button').off 'click'
         search.hide()

         # reset grid.
         grid = self.element.find '#grid'
         grid.jqGrid 'clearGridData'
         self.load_grid()
         
         # resize panel.
         self.resize()
      
      
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
            
            # substract result form height if shown.
            if self.element.find('#form').is(':visible') then height -= self.element.find('#form').height()

            # substract search form height if shown.
            if self.element.find('#search').is(':visible') then height -= self.element.find('#search').height()

            # resize grid.
            grid = self.element.find '#grid'
            grid.jqGrid 'setGridWidth', width
            grid.jqGrid 'setGridHeight', height
            
         , 100
      
      
      format_iso_date: (date)->
         if date isnt undefined and date isnt null
            date = edj.date.from_iso date
            return edj.date.format date, 'DD/MM/YYYY' 
         else return ''
