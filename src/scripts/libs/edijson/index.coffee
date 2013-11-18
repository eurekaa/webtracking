# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 09/11/13 22.11


define [
   'scripts/libs/edijson/database'
   'scripts/libs/edijson/gui'
   'scripts/libs/edijson/regexp'
   'scripts/libs/edijson/session'
   'scripts/libs/edijson/utility'
], (database, gui, regexp, session, utility)->
   
   database: database
   gui: gui
   regexp: regexp
   session: session
   utility: utility