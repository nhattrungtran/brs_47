$(document).ready(function() {
  $('#btn-follow').on('click', function() {
    action = ($(this).text().trim()) === 'Follow' ? 'POST' : 'DELETE';
    text = ($(this).text().trim()) === 'Follow' ? 'unfollow' : 'Follow';
    id = $('#followed_id').val();
    url = ($(this).text().trim()) === 'Follow' ? '/relationships' : '/relationships/' + id;
    $.ajax({
      type: action,
      url : url,
      dataType: 'json',
       data: {
        relationship: {
          id: id
        }
      },
      success: function(data) {
        $('#btn-follow').text(text);
      },
      error: function(error_message) {
        alert('error ' + error_message);
      }
    });
  });
});
