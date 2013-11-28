# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: gui
# Created: 18/11/13 20.34

define [
   'jquery_ui', 
   'scripts/libs/edijson/database'
   'scripts/libs/edijson/utility'
], ($, database, utility)->
   
   
   load_stylesheets: (urls)->
      if not utility.is_array urls then urls = new Array(urls)
      for url in urls
         if not utility.ends_with url, '.css' then url += '.css'
         link = document.createElement 'link'
         link.type = 'text/css'
         link.rel = 'stylesheet'
         link.href = url
         document.getElementsByTagName('head')[0].appendChild link
      return true
   
   
   load_combo: (element, url, label_empty, label_id, label_value, callback)->
      self = @
      database.select url, {}, (err, data)->
         if err then return self.show_message 'Errore di Sistema', err.message
         html = '<option value="">' + label_empty + '</option>'
         for item in data then html += '<option value="' + item[label_id] + '">' + item[label_value] + '</option>'
         $(element).html html
         if callback then callback null
   
   
   show_message: (title, message, buttons)->
      
      # add close button if not present.
      if not buttons then buttons = [
         text: 'chiudi', click: -> $(@).dialog 'close'; $(@).dialog 'destroy'; $(@).empty()
      ]
      
      # create container and append to body.
      container = $('<div>', { 'html': message })
      $('body').append container
      
      # open dialog.
      container.dialog
         show: 'bounce'
         title: title
         modal: true
         buttons: buttons
   
   
   show_progress: (title, message, position)->
   
      position = position || my: "center", at: "center", of: window
      
      # create container and append to body.
      container = $('<div>', { 'id': 'progressbar' }).css 'width': '500px', 'padding': '10px'
      message = $('<div>', { 'html': message }).css 'margin-bottom': '20px'
      container.append message
      progress = $('<div>').progressbar value: false
      progress.find('.ui-progressbar-value').addClass 'ui-corner-all'
      container.append progress
      $('body').append container
      
      # open dialog.
      container.dialog
         width: 400
         show: 'bounce'
         title: title
         modal: false
         closeOnEscape: false
         position: position
   
   hide_progress: ()->
      progress = $('body').find '#progressbar'
      progress.dialog 'close'
      progress.dialog 'destroy'
      progress.remove()