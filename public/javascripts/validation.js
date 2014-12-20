function hasHtml5Validation () {
  return typeof document.createElement('input').checkValidity === 'function';
}

if (hasHtml5Validation()) {
  $('.validate').submit(function (e) {
    if (!this.checkValidity()) {
      e.preventDefault();
      $(this).addClass('invalid');
    } else {
      $(this).removeClass('invalid');
    }
  });
}
