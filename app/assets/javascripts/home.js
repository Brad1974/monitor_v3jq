$(document).ready(function(){
  loadRoster();
  // loadProfile();
  // deleteChild();
  // loadStats();
  // loadReportIndex();
  // loadReport();

});
  // children ajax functions

  function loadRoster(){
    $.getJSON("/children.json/", function(data){
      var childList = ""
      data.forEach(function(details) {
        debugger;
        var link = "<div class='child-line'><li><a class='child-a' href = '/children/" + details.id + "'>" + details.name  +"</a></li></div> "
        // var link = "<div class='child-line'><li><a class= 'child-a' href= '/children/" + details.id + "'>" + details.first_name + " " + details.last_name + "</a></li></div> ";
        childList += link;
      })
      if (childList.length > 0) {
        $('.roster').html(childList)}
      else {
        $('.roster').html("<p>There are no children enrolled yet</p>")
      }
    })
  }
