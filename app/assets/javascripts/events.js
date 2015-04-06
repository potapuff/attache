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
                var robject = $('<li>'+responce+'</li>');
                $(this).find('ul').append(robject);
                robject.find('form').each(function (idx,obj){ form_ajax_register(obj)});
            });
            $(this).removeClass('hover');
        }
    });

    $('.newItem').draggable({containment: ".events", revert: true, revertDuration: 0});
    $(document).find('form').each(function (idx,obj){ form_ajax_register(obj)});

});


function form_ajax_register(id) {
    if (id == null) {
        return;
    }
    $(id)
        .bind("ajax:beforeSend", function (event, data, status, xhr) {
            var form = $(event.target);
            //TODO: fix it, broke send files via ajax
            //form.children().prop('disabled',true);
            form.addClass('disabled');
        })
        .bind("ajax:success", function (event, data, status, xhr) {
            console.log('...Good....');
            var form = $(event.target);
            var parent = form.parent();
            form.children().prop('disabled',false);
            form.replaceWith(data);
            parent.find('form').each(function (idx,obj){ form_ajax_register(obj)});
        })
        .bind("ajax:error", function (event, data, status, xhr) {
            console.log('...Error....');
            var form = $(event.target);
            var parent = form.parent();
            form.children().prop('disabled',false);
            form.replaceWith(data.responseText);
            parent.find('form').each(function (idx,obj){ form_ajax_register(obj)});
        });
}