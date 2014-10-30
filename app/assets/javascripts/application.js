// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require jquery.remotipart
//= require twitter/bootstrap
//= require turbolinks
// require select2
// require home
//= require_tree .


var removeRowLinkHTML = function(){
  return '\
          <span><a href="javascript:void(0);" class="remove-image-data-row">Remove</a></span>\
          ';
}

$(document).on("click", "#add_new_row", function(){
  var el= $("#image_data_fields"),
      imageDataRow = el.find(".image-data-fields-row:last")[0].outerHTML,
      els = el.find(".image-data-fields-row:last input");

  console.log(imageDataRow);
  el.append(imageDataRow);

  els.each(function(){
    console.log($(this).val());
  })

  if(el.find(".image-data-fields-row:last").find(".remove-image-data-row:first").length == 0){
    el.find(".image-data-fields-row:last").append(removeRowLinkHTML());
  }

  if(el.find(".image-data-fields-row:last").find("hr").length == 0){
    el.find(".image-data-fields-row:last").prepend('<hr>');
  }

});

$(document).on("click", ".remove-image-data-row", function(){
  var el = $(this);
  el.parent().parent().remove();
});

$(document).on("click", ".toggle-row", function(){
  var el = $(this);
  $(".image-data-row").hide();

  el.parent().parent().next(".image-data-row").show("slow", "linear");
});
