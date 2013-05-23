updateCountdown = ->
  remaining = 140 - jQuery("#minituit_content").val().length
  jQuery(".countdown").text remaining + "."
  if (remaining < 0)
  	jQuery("#submitItuit").attr('disabled', 'disabled')
  else
  	jQuery("#submitItuit").removeAttr('disabled')

jQuery ->
  updateCountdown()
  $("#minituit_content").change updateCountdown
  $("#minituit_content").keyup updateCountdown