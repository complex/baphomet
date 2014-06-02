$(document).on 'ready', ->

  form = $('form')
  token_field = $('#payment_card_token')
  token = token_field.val()

  if token != ''
    Stripe.getToken token, (status, response) ->
      number_text = "#{ response.card.type } ending #{ response.card.last4 } <a href=''>Change card</a>"
      expiration_text = "#{ response.card.exp_month } / #{ response.card.exp_year }"
      $('.existing.number p').html number_text
      $('.existing.expiration p').html expiration_text

  form.on 'submit', (event) ->

    return unless token_field.val() == ''

    errors_container = $('div.errors')
    number = clean $('#payment_number').val()
    expiration = $('#payment_expiration').val()
    month = clean expiration.split('/')[0]
    year = clean expiration.split('/')[1]

    Stripe.card.createToken {
      number: number
      exp_month: month
      exp_year: year
    }, (status, response) ->
      if status >= 200 and status < 300
        token_field.val response.id
        form.unbind().submit()
      else if status >= 400 and status < 500
        code = response.error.code
        message = switch
          when code == 'invalid_number'
            "Your card's number is incorrect."
          when code == 'invalid_expiry_year'
            "Your card's expiration date is incorrect."
          when code == 'invalid_expiry_month'
            "Your card's expiration date is incorrect."
          when code == 'card_declined'
            "Your card was declined."
          else
            response.error.message
        errors_container.html "<p>#{ message }</p>"
      else if status >= 500
        errors_container.html "<p>There was a problem communicating with the card processor. Please try again in a minute.</p>"

    return false

  form.on 'click', '.existing a', (event) ->
    form.find('.existing').hide()
    form.find('.new').show()
    form.find('#payment_card_token').val ''
    form.find('#payment_number').focus()
    return false

clean = (string) ->
  (string or '').replace /[^\d]/g, ''
