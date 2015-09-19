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
    $('#weeksDiv').hide()
    $('#monthDiv').hide()
    $('#todayDiv').show()

  $('#weeksButton').on 'click', ->
    $('#todayButton').removeClass('btn-primary');
    $('#monthButton').removeClass('btn-primary');
    $('#weeksButton').addClass('btn-primary')
    $('#todayDiv').hide()
    $('#monthDiv').hide()
    $('#weeksDiv').show()
    $('.weekend').hide()

  $('#monthButton').on 'click', ->
    $('#todayButton').removeClass('btn-primary');
    $('#weeksButton').removeClass('btn-primary');
    $('#monthButton').addClass('btn-primary')
    $('#todayDiv').hide()
    $('#weeksDiv').hide()
    $('#monthDiv').show()

  $('.weekend').hide()

  $('#toggleWeekends').on 'change', ->
    $('.weekend').toggle()

  $('.table > tbody > tr').on 'click', (e) ->
    e.preventDefault()
    $.ajax(url: $(e.currentTarget).data('link'), dataType: 'script')
