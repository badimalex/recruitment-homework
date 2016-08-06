$ ->
  $('body').on 'click', '.edit-comment-link', ->
    event.preventDefault();
    $(this).hide();
    comment_id = $(this).data('comment-id')
    $('form#edit-comment-' + comment_id).show();
