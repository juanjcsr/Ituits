updateCountdown = ->
  remaining = 140 - jQuery("#minituit_content").val().length
  jQuery(".countdown").text remaining + " characters remaining"

jQuery ->
  updateCountdown()
  $("#minituit_content").change updateCountdown
  $("#minituit_content").keyup updateCountdown