# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: database
# Created: 09/11/13 22.11

define ['jquery', 'scripts/libs/edijson/config', 'scripts/libs/edijson/utility'], ($, config, utility)->
   
   rest = (verb, type, target, parameters, options, callback)->
      if typeof options is 'function' then callback = options; options = {}
      parameters = parameters || {}
      options = options || {}
      async = (if utility.is_defined(options.async) then options.async else true)
      $.ajax
         url: config.EDIJSON_URL
         type: verb
         async: async
         dataType: 'json'
         data:
            EDIJSON_SECURITY_USERNAME: config.EDIJSON_SECURITY_USERNAME
            EDIJSON_SECURITY_PASSWORD: config.EDIJSON_SECURITY_PASSWORD
            url: 'edijson/' + type + '/' + target.replace('.', '/') 
            parameters: JSON.stringify(parameters)
            options: JSON.stringify(options)
         success: (data)->
            if data['IsError'] is true then callback data, null
            else callback null, data
         error: (xhr, status, err)-> callback Message: 'L\'host ' + config.EDIJSON_URL + ' non è raggiungibile.' , null
   
   procedure: (name, parameters, options, callback)->
      rest 'GET', 'procedure', name, parameters, options, callback
   
   select: (target, parameters, options, callback)-> 
      rest 'GET', 'table', target, parameters, options, callback
   
   insert: (target, parameters, options, callback)-> 
      rest 'POST', 'table', target, parameters, options, (err, data)->
         if not err then data = data[0]
         callback err, data
   
   update: (target, parameters, options, callback)-> 
      rest 'PUT', 'table', target, parameters, options, (err, data)->
         if not err then data = data[0]
         callback err, data
   
   delete: (target, parameters, options, callback)-> 
      rest 'DELETE', 'table', target, parameters, options, (err, data)->
         if not err then data = data[0]
         callback err, data