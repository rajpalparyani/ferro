DEFAULT_AMT = 995
  
amt = DEFAULT_AMT

THANK_YOU = """<p class="thankyou">Thank you for donating #{localStorage.orders} order#{'s' unless localStorage.orders is '1'} of chicken panang!</p>"""

complete = (result, type) ->
  name = $('#name').val()
  track 'Donations', type, name, amt
  if type is 'stripe'
    $.post 'https://donate.getferro.com/donations', {token: result.id, name, amt}

  localStorage.donated = true
  localStorage.orders = (amt / DEFAULT_AMT).toFixed 2
  $('#donate').hide()
  $('#donate').append THANK_YOU


update_amount_left = ->
  left = (Math.max(
    amt - (amt * 0.029) - 30
    0
  )/100).toFixed 2
  l 'left'
  l left
  $('.stripe').text '$ ' + left
  
  $('.bitcoin').text '$ ' + (Math.max(amt, 0)/100).toFixed 2

$ ->
  l 'what'  


  # how do you have - in attr name in coffeecup?
  $('.coinbase-button')
    .attr('data-code', '5bb2f730894ac0de1df2fff0c3bdd8fe')
    .attr('data-button-style', 'none')

  if localStorage.donated
    $('#donate > img').hide()
    $('#donate').append THANK_YOU

  $.get 'https://donate.getferro.com/donations', (data) ->
    for donation in data.donations
      li = "<li>#{donation.name}<code>$#{donation.amt}</code>#{donation.created_at}</li>"
      $('#donations').append $(li)

  update_amount_left()

  $('#amount').on 'change keyup paste input', ->
    new_amt = parseFloat($('#amount').val()) * 100
    l new_amt
    if new_amt isnt amt
      l 'not amt'
      amt = new_amt
      l amt
      update_amount_left()

  $('#stripe').click (e) ->
    track 'Donation clicks', 'stripe'
    l 'here'
    l amt

    if amt <= 50
      alert 'Minimum card charge is 50 cents.'
      return
  
    token = (res) =>
      complete res, 'stripe'

    StripeCheckout.open 
      key:         'pk_test_dqK3ga37dNAty3AQsvfEq2pe',
      amount:      amt,
      currency:    'usd',
      name:        'Ferro',
      description: 'Donation',
      panelLabel:  'Donate',
      token:       token
      image:       'images/icon-128.gif'

  $('#bitcoin').click ->
    track 'Donation clicks', 'bitcoin'
    $('.coinbase-button').attr 'data-custom', $('#name').val()
    $(document).trigger 'coinbase_show_modal', '5bb2f730894ac0de1df2fff0c3bdd8fe'
    false

  $(document).on 'coinbase_payment_complete', (e, code) ->
    complete {}, 'bitcoin'
