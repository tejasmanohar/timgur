$(document).ready(function() { 
  $('#embedded-subscribe-form').ajaxForm(function() { 
    $('<p>Subscribed!</p>').insertAfter('form');
  }); 
}); 