$(document).on 'page:change', ->
  $('#monthpicker').on 'dp.change', ->
    $('#monthForm').submit()