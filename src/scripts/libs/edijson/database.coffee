# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: database
# Created: 09/11/13 22.11

define ['jquery', 'scripts/libs/edijson/utility'], ($, utility)->
   
   rest = (verb, table, parameters, options, callback)->
      
      if typeof options is 'function' then callback = options; options = {}
      parameters = parameters || {}
      options = options || {}
      $.ajax
         url: '/edijson/table/' + table.replace('.', '/'),
         type: verb,
         async: (if utility.is_defined(options.async) then options.async else true)
         dataType: 'json'
         data:
            EDIJSON_SECURITY_USERNAME: 'n0v4t1'
            EDIJSON_SECURITY_PASSWORD: 'aa389a8231c5370ab0c38e9fd4e0d17a'
            parameters: JSON.stringify(parameters)
            options: JSON.stringify(options)
         success: (data)->
            if data['IsError'] is true then callback data, null
            else callback null, data
         error: (xhr, status, err)-> callback err, null
   
   
   select: (table, parameters, options, callback)-> rest 'GET', table, parameters, options, callback
   
   insert: (table, parameters, options, callback)-> 
      rest 'POST', table, parameters, options, (err, data)->
         if not err then data = data[0]
         callback err, data
   
   update: (table, parameters, options, callback)-> 
      rest 'PUT', table, parameters, options, (err, data)->
         if not err then data = data[0]
         callback err, data
   
   delete: (table, parameters, options, callback)-> 
      rest 'DELETE', table, parameters, options, (err, data)->
         if not err then data = data[0]
         callback err, data