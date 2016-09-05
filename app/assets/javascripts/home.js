$(document).on("turbolinks:load", function(){
  loadRoster();
  loadProfile();
  deleteChild();
  // loadStats();
  // loadReportIndex();
  // loadReport();

});
  // children ajax functions

  function loadRoster(){
    $.getJSON("/children.json/", function(data){
      var childList = ""
      data.forEach(function(details) {
        var link = "<div class='child-line'><li><a class='child-a' href = '/children/" + details.id + "'>" + details.name  +"</a></li></div> "
        childList += link;
      })
      if (childList.length > 0) {
        $('.roster').html(childList)}
      else {
        $('.roster').html("<p>There are no children enrolled yet</p>")
      }
    })
  }

  function loadProfile(){
  $('.roster').on('click', 'a.child-a', function(e){
    e.preventDefault();
    var childLine = $(this).closest('div')
    var url = $(this).attr('href')
    $.getJSON({url:url, locator: childLine}, function(data){})
    .done(buildChild)
  })
}

function buildChild(data){
  var locator = this.locator
  var newChild = new Child(data.id, data.name, data.birthdate, data.diapers_inventory, data.bully_rating, data.ouch_rating, data.kind_acts.length, data.gifts.length);
  newChild.insertIntoPage(locator);
}


function Child(id, name, birthdate, diapers_inventory, bully_rating, ouch_rating, kind_acts, gifts){
  this.id = id
  this.name = name;
  this.birthdate = birthdate;
  this.diapers_inventory = diapers_inventory;
  this.bully_rating = bully_rating;
  this.ouch_rating = ouch_rating;
  this.kind_acts = kind_acts;
  this.gifts = gifts;
}


Child.prototype.insertIntoPage = function(locator){
  var lineOne = "<hr><p> Birthdate " + this.birthdate + "</p> "
  var lineTwo = "<p> Bully Rating: " + this.bully_rating + "</p> "
  var lineThree = "<p> Ouch Rating: " + this.ouch_rating + "</p> "
  var lineFour = " <p> Observed Performing Acts of Kindness: " + this.kind_acts + "</p> "
  var lineFive = " <p> Observed Receiving Acts of Kindness: " + this.gifts + "</p> "
  var lineSeven = " <p> Current Diaper Inventory: " + this.diapers_inventory + "</p> "
  var lineEight = "<p><a href='/children/" + this.id + "/edit'>edit profile</a> - "
  var lineNine = "<span class='fake-link' id='delete' data-details='" + this.id + "'>delete profile</span></p> "
  var lineTen = "<h5><span class='fake-link' id='loadIndex' data-details='" + this.id + "'>View Daily Reports</span></h5>"
  var lineTen1 = "<div class='report-area' data-details='" + this.id + "'></div>"
  var lineEleven = "<h5><a href='/children/" + this.id + "/daily_reports/new'>Write a new report</a></h5>"
  var template ="<div data-details='" + this.id + "' class='profile'>" + lineOne + lineTwo + lineThree + lineFour + lineFive + lineSeven + lineEight + lineNine + lineTen + lineTen1+ lineEleven +"<hr></div>"
  if ($(locator).find('p').length === 0) {
  $(locator).append(template);}
  else {$(locator).find('.profile').remove() }
}

function deleteChild(){
  $('.roster').on('click', 'span#delete', function(event){
    var choice = confirm('Do you really want to delete this record?');
    if(choice === true) {
      event.stopPropagation();
      var url = "/children/" + $(this).data('details')
      $.ajax({url: url, type: "DELETE"})
      .done(function(success){
        $('div [data-details=' +success.id +']').parent().remove()
      });
    };
  });
};
