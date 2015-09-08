$(document).on 'page:change', ->

  $('#monthpicker').on 'dp.change', ->
    $('#monthForm').submit()

  $('#toggleView').bootstrapSwitch()
  $('#toggleView').on 'switchChange.bootstrapSwitch', ->
    $('#monthDiv').fadeToggle()
    $('#weeksDiv').fadeToggle()

  $('#todayButton').on 'click', ->
    $('#weeksButton').removeClass('btn-primary');
    $('#monthButton').removeClass('btn-primary');
    $('#todayButton').addClass('btn-primary')
    $('#weeksDiv').fadeOut()
    $('#monthDiv').fadeOut()
    $('#todayDiv').fadeIn()

  $('#weeksButton').on 'click', ->
    $('#todayButton').removeClass('btn-primary');
    $('#monthButton').removeClass('btn-primary');
    $('#weeksButton').addClass('btn-primary')
    $('#todayDiv').fadeOut()
    $('#monthDiv').fadeOut()
    $('#weeksDiv').fadeIn()

  $('#monthButton').on 'click', ->
    $('#todayButton').removeClass('btn-primary');
    $('#weeksButton').removeClass('btn-primary');
    $('#monthButton').addClass('btn-primary')
    $('#todayDiv').fadeOut()
    $('#weeksDiv').fadeOut()
    $('#monthDiv').fadeIn()

  $('.table > tbody > tr').on 'click', (e) ->
    e.preventDefault()
    $.ajax(url: $(e.currentTarget).data('link'), dataType: 'script')
