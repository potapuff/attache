$(function () {
    $(".event").droppable({
        accept: ".newItem",
        over: function (event, ui) {
            $(this).addClass('hover');
        },
        out: function (event, ui) {
            $(this).removeClass('hover');
        },
        drop: function (event, ui) {
            var type = $(ui.draggable).attr('data-type');
            $.ajax({
                url: "/events/" + $(this).attr('id') + "/items/new?type=" + type,
                context: $(this)
            }).done(function (responce) {
                $(this).find('ul').append('<li>' + responce + '</li>');
            });
            $(this).removeClass('hover');
        }
    });

    $('.newItem').draggable({containment: ".events", revert: true, revertDuration: 0});

});


function form_ajax_register(id) {
    $(id)
        .bind("ajax:beforeSend", function (event, data, status, xhr) {
            event.target.hide();
        })
        .bind("ajax:success", function (event, data, status, xhr) {
            console.log('...Good....');
            console.log(xhr);
            console.log(data);
        })
        .bind("ajax:error", function (event, data, status, xhr) {
            console.log('...Error....');
            console.log(xhr);
            console.log(data);
        });
}
