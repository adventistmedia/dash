
// default asset inserter
function assetInsertCallback(el, object){
  var parentElement = el.parents('.file-asset').first();
  parentElement.find('.file-value').val(object.id);
  var preview = parentElement.find('.file-preview');
  if( object.thumb ){
    preview.html('<img src="'+object.thumb+'">');
  }else{
    preview.html("<span class='filename'>"+object.filename+"</span>");
  }
}

// click on image to insert
$(document).on('click', '.chooser-file-insert', function(e){
  e.preventDefault();
  var assetId = $(this).data('asset-id');
  var trigger = parent.$.fancybox.getInstance().$lastFocus;
  if( trigger == 'editor' ){
    insertImageToEditor(asset_list[ assetId ], caption );
  }else{
    parent[trigger.data('callback')](trigger, asset_list[ assetId ] );
  }
  parent.$.fancybox.close();
});

//return timestamp as id
function timestamp_id(){
  time = new Date().getTime();
  return time & 0xfffffff;
}
function bytesToSize(bytes) {
  var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  if (bytes == 0) return 'n/a';
  var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
  return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
}

function chooserUploader(){
  // DOCUMENT UPLOADER
  $('.document-fileupload').fileupload({
    dropZone: $('#dropzone'),
    autoUpload: true,
    paramName: 'file',
    dataType: 'xml', // S3 returns xml, so expect xml in return
    singleFileUploads: false,
    limitMultiFileUploads: 1,
    sequentialUploads: true,
    multipart: true,
    disableImageMetaDataLoad: true,
    add: function (e, data) {

      var uploadErrors = [];
      var maxSize = 3000000; // 3MB
      var acceptFileTypes = /^application\/(pdf)$/i;
      data.files[0]['id'] = "u-"+timestamp_id();
      if(data.files[0]['type'].length && !acceptFileTypes.test(data.files[0]['type'])) {
          uploadErrors.push('Not an accepted file type');
      }
      if(data.files[0]['size'] > maxSize) {
        uploadErrors.push('File size must be be less than 3MB');
      }
      if(uploadErrors.length > 0) {
        var status = uploadErrors.join("\n");
      } else {
        var status = `<div class="progress"><div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div></div>`;
        data.submit();
      }
      var html = $(`<div id="${data.files[0]['id']}" class="upload-item">
                      <div class="title">${data.files[0].name}</div>
                      <div class="status">${status}</div>
                    </div>`);
      $(html).appendTo('#upload-list');
    },
    progress: function (e, data) {
      var percentage = Math.round((data.loaded * 100.0) / data.total);
      var bar = $("#"+data.files[0]['id']+" .progress-bar");
      bar.text(percentage + "%");
      bar.css("width", percentage + "%");
      bar.attr("aria-valuenow", percentage);
    },
    fail: function (e, data) {
      $("#"+data.files[0]['id']+" .status").text("Upload failed");
    }
  })
  .off("fileuploaddone").on("fileuploaddone", function (e, data) {
    var status_el = $("#"+data.files[0]['id']+" .status");
    status_el.text("Almost there...");
    var response = $(data.jqXHR.responseText);
    ajax_data = {
      file:{
        name: data.files[0].name,
        dom_id: data.files[0].id,
        tag: response.find('eTag').text(),
        location: response.find('Location').text(),
        key: response.find('Key').text(),
        content_type: data.files[0].type,
        file_size: data.files[0].size
      }
    }
    // $('.upload-field').each(function(index, el){
    //   ajax_data[$(el).attr('name')] = $(el).val();
    // })
    $.ajax({
      url: $(this).parents("form").attr("action"),
      type: 'POST',
      data: ajax_data,
      dataType: 'script',
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        status_el.text('500 error adding to server')
      }
    });
  })

  // IMAGE UPLOADER
  $(".image-fileupload")
  .cloudinary_fileupload({
    // Uncomment the following lines to enable client side image resizing and valiation.
    // Make sure cloudinary/processing is included the js file
    //disableImageResize: false,
    sequentialUploads: true,
    dropZone: "#dropzone",
    add: function (e, data) {
      var uploadErrors = [];
      var acceptFileTypes = /^image\/(gif|jpe?g|png)$/i;
      var maxSize = 307200; // 300kb
      data.files[0]['id'] = "u-"+timestamp_id();
      if(data.files[0]['type'].length && !acceptFileTypes.test(data.files[0]['type'])) {
          uploadErrors.push('Not an accepted file type');
      }
      if(data.files[0]['size'] > maxSize) {
        uploadErrors.push('File size must be be less than 300Kb');
      }
      if(uploadErrors.length > 0) {
        var status = uploadErrors.join("\n");
      } else {
        var status = `<div class="progress"><div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div></div>`;
        data.submit();
      }
      var html = $(`<div id="${data.files[0]['id']}" class="upload-item">
                      <div class="title">${data.files[0].name}</div>
                      <div class="status">${status}</div>
                    </div>`);
      $(html).appendTo('#upload-list');
    },
    progress: function (e, data) {
      var percentage = Math.round((data.loaded * 100.0) / data.total);
      var bar = $("#"+data.files[0]['id']+" .progress-bar");
      bar.text(percentage + "%");
      bar.css("width", percentage + "%");
      bar.attr("aria-valuenow", percentage);
    },
    fail: function (e, data) {
      $("#"+data.files[0]['id']+" .status").text("Upload failed");
    }
  })
  .off("cloudinarydone").on("cloudinarydone", function (e, data) {
    var status_el = $("#"+data.files[0]['id']+" .status");
    status_el.text("Almost there...");

    var result = data.result;
    result['title'] = data.files[0].name;
    result['dom_id'] = data.files[0].id;
    var ajax_data = {}
    ajax_data.photo = result;
    $.ajax({
      type: "POST",
      url: $(this).parents("form").attr("action"),
      data: ajax_data,
      dataType: 'script',
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        status_el.text('500 error adding to server')
      }
    });
  });

}
$(document).on('turbolinks:load', chooserUploader);