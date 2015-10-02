$(document).on 'page:change', ->

  $('#monthpicker').on 'dp.change', ->
    $('#monthForm').submit()

  $('#toggleView').bootstrapSwitch()
  $('#toggleView').on 'switchChange.bootstrapSwitch', ->
    $('#monthDiv').fadeToggle()
    $('#weeksDiv').fadeToggle()

  $('#todayButton').on 'click', ->
    $.ajax(url: $('#weekTable tbody tr[data-day="' + moment().format("YYYY-MM-DD") + '"]').data('link'), dataType: 'script', success: enableText)

  $('#weeksButton').on 'click', ->
    $('#todayButton').removeClass('active')
    $('#monthButton').removeClass('active')
    $('#weeksButton').addClass('active')
    $('#monthDiv').hide()
    $('#weeksDiv').show()
    $('.weekend').hide()

  $('#monthButton').on 'click', ->
    $('#todayButton').removeClass('active')
    $('#weeksButton').removeClass('active')
    $('#monthButton').addClass('active')
    $('#weeksDiv').hide()
    $('#monthDiv').show()

  $('.weekend').hide()

  $('#toggleWeekends').on 'change', ->
    $('.weekend').toggle()

  $('.table > tbody > tr').on 'click', (e) ->
    e.preventDefault()
    $.ajax(url: $(e.currentTarget).data('link'), dataType: 'script', success: enableText)


enableText = () ->
  $('.timepicker').on 'dp.change', updateText
  updateText()

updateText = () ->
  worked_from = moment($('#worked_from_picker > input').val(), 'HH:mm')
  worked_until = moment($('#worked_until_picker > input').val(), 'HH:mm')
  break_duration = moment($('#break_duration_picker > input').val(), 'HH:mm')

  duration = worked_until.subtract(worked_from).subtract(break_duration)
  small_text = if duration.isValid() then '<small>' + duration.format('HH:mm') + '</small>' else ''

  $('#modalHeading').html('<h1>' + moment($('#modalHeading').data('date')).format('LL') + small_text + '</h1>')
