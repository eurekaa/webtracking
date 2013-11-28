# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: api
# Created: 21/11/13 16.15


define ['scripts/libs/edijson/config', 'scripts/libs/edijson/utility'], (config, utility)->

   rpc = (verb, api, parameters, options, callback)->
      if typeof options is 'function' then callback = options; options = {}
      parameters = parameters || {}
      options = options || {}
      async = (if utility.is_defined(options.async) then options.async else true)
      $.ajax
         url: config.EDIJSON_URL + 'api/' + api.replace('.', '/')
         type: verb
         async: async
         dataType: 'json'
         data:
            EDIJSON_SECURITY_USERNAME: config.EDIJSON_SECURITY_USERNAME
            EDIJSON_SECURITY_PASSWORD: config.EDIJSON_SECURITY_PASSWORD
            parameters: JSON.stringify(parameters)
            options: JSON.stringify(options)
         success: (data)->
            if data['IsError'] is true then callback data, null
            else callback null, data
         error: (xhr, status, err)-> callback err, null
   
   call: (api, parameters, options, callback)-> rpc 'GET', api, parameters, options, callback