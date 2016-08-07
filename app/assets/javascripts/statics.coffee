$ ->
  $(".slides > div:gt(0)").hide();
  $('body').on 'click', '.arrow', ->
    $current = $('.slides > div:first')
    $current.fadeOut(1000)
    if $(this).data('action')=='next'
      $current.next().fadeIn(1000).end().appendTo('.slides')
    else
      $('.slides > div:last').fadeIn(1000).prependTo('.slides')
