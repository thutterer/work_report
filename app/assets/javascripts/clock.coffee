updateClock = ->
  now = new Date()
  time = (if now.getHours() < 10 then '0' else '') + now.getHours() + ":" +
    (if now.getMinutes() < 10 then '0' else '') + now.getMinutes()
  document.getElementById("clock").innerHTML = time
  setTimeout updateClock, 10000 # 10 seconds

$(document).on 'page:change', ->
  updateClock()