# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: session
# Created: 11/11/13 20.54

define ['scripts/libs/edijson/utility'], (utility)->
   
   get: (name)-> 
      value = sessionStorage.getItem name
      if ((utility.starts_with(value, '{') and utility.ends_with(value, '}') or (utility.starts_with(value,'[') and utility.ends_with(value, ']'))))
         value = JSON.parse value
      return value
   
   set: (name, value)->
      if utility.is_object value then value = JSON.stringify value
      sessionStorage.setItem name, value 
   
   remove: (name)-> sessionStorage.removeItem name
   
   clear: -> sessionStorage.clear() 