# Company: Eureka²
# Developer: Stefano Graziato
# Email: stefano.graziato@eurekaa.it
# Homepage: http://www.eurekaa.it
# GitHub: https://github.com/eurekaa

# File Name: index
# Created: 09/11/13 22.11


define [
   'scripts/libs/edijson/api'
   'scripts/libs/edijson/database'
   'scripts/libs/edijson/date'
   'scripts/libs/edijson/regexp'
   'scripts/libs/edijson/session'
   'scripts/libs/edijson/ui'
   'scripts/libs/edijson/utility'
], (api, database, date, regexp, session, ui, utility)->

   api: api
   database: database
   date: date
   regexp: regexp
   session: session
   ui: ui
   utility: utility