// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

$(function() {
    document.body.addEventListener('ajax:send', function(event) {
        $('[type="submit"].all_disable').attr('disabled', true);//ボタンを無効化する
    });
    document.body.addEventListener('ajax:send', function(event) {
        console.log('ajax send');
    });
    document.body.addEventListener('ajax:success', function(event) {
        console.log('ajax success');
    });
    document.body.addEventListener('ajax:error', function(event) {
        console.log('ajax error');
    });
});