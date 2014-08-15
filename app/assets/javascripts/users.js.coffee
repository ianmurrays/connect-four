pusher = new Pusher('5e2a463dcf1bde1d0127')
channel = pusher.subscribe('moves')

setupBoard = (data) ->
  user_id = $('table').data('user-id')
  if user_id == data.turn
    $('.btn-drop').prop('disabled', false)
    $('#your_turn').show()
    $('#not_your_turn').hide()
  else
    $('.btn-drop').prop('disabled', true)
    $('#your_turn').hide()
    $('#not_your_turn').show()

channel.bind 'reset', (data) ->
  # Reset the board
  $('td div').removeClass('red')
             .removeClass('blue')

  setupBoard(data)

channel.bind 'drop', (data) ->
  # No need to drop a disc if this notification was triggered by us
  color = $('table').data('color')
  $("table[data-user-id!=#{data.user_id}] #cell_#{data.row}_#{data.col} div").addClass(color)

  setupBoard(data)

channel.bind 'win', (data) ->
  user_id = $('table').data('user-id')

  alert('You lose! :(') if user_id != data.user_id

  $('.btn-drop').prop('disabled', true)

# Disable buttons once they're clicked!
$ -> $('.btn-drop').click ->
  $('.btn-drop').prop('disabled', true)
  $(this).parent().submit()
