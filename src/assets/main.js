function copytext(id) {
  var copyText = document.getElementById(id).innerText;
  var $temp = $("<textarea>");
  $("body").append($temp);
  $temp.val(copyText.trim()).select();
  document.execCommand("copy");
  $temp.remove();
}
