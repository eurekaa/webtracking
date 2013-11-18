# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: utility
# Created: 11/11/13 20.30


define ['underscore'], (u)->
   
   # object functions.
   is_object: (object)-> u.isObject object
   is_equal: (object, other)-> u.isEqual object, other
   is_empty: (object)-> u.isEmpty object
   is_array: (object)-> u.isArray object
   is_function: (object)-> u.isFunction object
   is_arguments: (object)-> u.isArguments object
   is_string: (object)-> u.isString object
   is_number: (object)-> u.isNumber object
   is_nan: (object)-> u.isNaN object
   is_finite: (object)-> u.isFinite object
   is_boolean: (object)-> u.isBoolean object
   is_regexp: (object)-> u.isRegExp object
   is_null: (object)-> u.isNull object
   is_undefined: (object)-> u.isUndefined object
   is_defined: (object)-> !u.isUndefined object
   is_element: (object)-> u.isElement object
   
   # string functions.
   to_upper: (string)-> string.toUpperCase()
   to_lower: (string)-> string.toLowerCase()
   capitalize: (string)-> @.to_upper(string.charAt 0) + @.to_lower(string.slice 1)
   repeat: (string, times)->
      if not times or times < 1 then times = 1
      new Array(times + 1).join string
   starts_with: (string, token)-> new String(string).slice(0, token.length) == token
   ends_with: (string, token)-> new String(string).slice(-token.length) == token
   contains: (string, token)-> string.indexOf token != -1