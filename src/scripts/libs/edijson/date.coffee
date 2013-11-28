# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: date
# Created: 21/11/13 12.13

define [
   'moment'
   'scripts/libs/edijson/utility'
], (moment, utility)->
   
   
   # date patterns.
   iso_pattern: 'YYYY-MM-DDTHH:mm:ssZ'
   default_pattern: 'DD-MM-YYYY'
   
   
   is_valid: (date)->
      
      # date must be a valid value.
      if date is undefined or date is null or date is '' then return false
      
      # attention: date must be parsed before in order to work with chrome.
      if utility.is_string(date) then date = @.parse date
      
      # create new date and test if valid.
      date = new moment date
      return date.isValid()
   
   
   parse: (string, pattern)->
      
      # if not defined use default pattern.
      pattern = if utility.is_string(pattern) then pattern else @.default_pattern
      
      # create a moment date and then return converted into javascript date.
      return new moment(string, pattern).toDate()
   
   
   format: (date, pattern)->
      
      # if not specified use default italian pattern.
      pattern = if utility.is_undefined pattern then @.default_pattern else pattern
      
      # return formatted date.
      date = new moment date
      return date.format pattern
   
   
   from_iso: (string)->
      
      # parse date from iso pattern. 
      return @.parse string, @.iso_pattern
   
   
   to_iso: (date)-> 
      
      # parse date if a string.
      if utility.is_string(date) then date = @.parse date
      
      # format date into iso pattern.
      return @.format date, @.iso_pattern
