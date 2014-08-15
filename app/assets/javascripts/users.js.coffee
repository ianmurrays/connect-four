# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

pusher = new Pusher('5e2a463dcf1bde1d0127')
channel = pusher.subscribe('moves')

channel.bind 'reset', (data) ->
  # Reset the board
  $('td div').removeClass('red')
             .removeClass('blue')

channel.bind 'drop', (data) ->
  # No need to drop a disc if this notification was triggered by us
  color = $('table').data('color')
  $("table[data-user-id!=#{data.user_id}] #cell_#{data.row}_#{data.col} div").addClass(color)

channel.bind 'win', (data) ->
  user_id = $('table').data('user-id')

  alert('You lose! :(') if user_id != data.user_id
