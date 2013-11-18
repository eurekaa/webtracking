# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: regexp
# Created: 18/11/13 22.27


define ['scripts/libs/edijson/utility'], (utility)->
   
   # regular expression testing function.
   test: (string, regexp)->
      if utility.is_string(regexp) and utility.is_defined(@[regexp]) then regexp = @[regexp]
      regexp = new RegExp regexp
      match = string.match regexp
      return match and match.length > 0
   
   
   # regular expressions patterns.
   email: '^([a-zA-Z0-9]+([\.+_-][a-zA-Z0-9]+)*)@(([a-zA-Z0-9]+((\.|[-]{1,2})[a-zA-Z0-9]+)*)\.[a-zA-Z]{2,6})$'