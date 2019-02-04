// JQuery is not required for Bongloy.js

// Here we get our Bongloy Publishable Key from a meta tag attribute in the HTML head
// so we don't need to hard-code it the JavaScript
var stripe = Stripe(document.querySelector("#pk").value);
var elements = stripe.elements();
var card = elements.create('card')
card.mount("#card-element")

var form = document.forms['element_form'];
form.addEventListener('submit', submitHandler, false);

// Submit handler for checkout form.
function submitHandler(event) {
  event.preventDefault();
  console.log(document.querySelector("#pk").value)

  stripe.createToken(card).then(function(result) {
    var errorElement = document.getElementById('card-errors');
    console.log(result.token)
    if (result.error) {
      errorElement.textContent = result.error.message;
    } else {
      errorElement.textContent = '';

      var hiddenInput = document.createElement('input');
      hiddenInput.setAttribute('type', 'hidden');
      hiddenInput.setAttribute('name', 'new_charge[token]');
      hiddenInput.setAttribute('value', result.token.id);
      form.appendChild(hiddenInput);

      form.submit();
    }
  });
}

// if (statusCode === 201) {
//   // On success, set token in your checkout form
//   document.querySelector('[data-name="cardToken"]').value = response.id;
//   console.log(response.id)

//   // Then, submit the form
//   // checkoutForm.submit();
// }
// else {
//   // If unsuccessful, display an error message.
//   // Note that `response.error.message` contains a preformatted error message.
//   document.querySelector("input[type=submit]").removeAttribute('disabled');
//   errorMessages.classList.remove('hidden');
//   errorMessages.classList.add('show');
//   errorMessages.innerHTML = response.error.message;
// }
