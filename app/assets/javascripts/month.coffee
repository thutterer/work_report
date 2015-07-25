$(document).on 'page:change', ->
  $('#monthpicker').on 'dp.change', ->
    $('#monthForm').submit()
  $('#toggleView').bootstrapSwitch()
  $('#toggleView').on 'switchChange.bootstrapSwitch', ->
    $('#tableMonth').fadeToggle()
    $('#divWeeks').fadeToggle()