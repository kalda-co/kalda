const registerForm = document.querySelector(".js-waitlist-form");

if (registerForm) {
  registerForm.addEventListener('submit', function (e) {
    e.preventDefault();
    setTimeout(submitForm, 1000);
    var formSubmitted = false;

    function submitForm() {
      if (!formSubmitted) {
        formSubmitted = true;
        registerForm.submit();
      }
    }

    plausible('waitlist', { callback: submitForm });
  })

}

// TODO Add a logSubmit event ? see https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement/submit_event
// TODO Add custom props such as OS and device, see https://plausible.io/docs/custom-event-goals
