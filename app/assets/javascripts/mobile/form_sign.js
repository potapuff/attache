$(document).ready(function () {

    $(document).find('form').each(function (idx, obj) {
        form_ajax_register(obj)
    });

    slideout = new Slideout({
        'panel': document.getElementById('panel'),
        'menu': document.getElementById('menu'),
        'padding': 256,
        'tolerance': 70
    });

    $('#menuToggle').bind('click', function () {
        slideout.toggle()
    });

});

function form_ajax_register(id) {
    if (id == null) {
        return;
    }
    $(id)
        .bind("ajax:beforeSend", function (event, data, status, xhr) {
            var form = $(event.target);
            form.children().prop('disabled',true);
            form.addClass('disabled');
        })
        .bind("ajax:success", function (event, data, status, xhr) {
            console.log('...Good....');
            var form = $(event.target);
            var parent = form.parent();
            form.children().prop('disabled', false);
            form.replaceWith(data);
            parent.find('form').each(function (idx, obj) {
                form_ajax_register(obj)
            });
        })
        .bind("ajax:error", function (event, data, status, xhr) {
            console.log('...Error....');
            var form = $(event.target);
            var parent = form.parent();
            form.children().prop('disabled', false);
            form.replaceWith(data.responseText);
            parent.find('form').each(function (idx, obj) {
                form_ajax_register(obj)
            });
        });
}
