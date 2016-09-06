$(document).on("turbolinks:load", function(){
  loadRoster();
  loadProfile();
  deleteChild();
  loadStats();
  loadReportIndex();
  loadReport();
  deleteReport();

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

function loadStats(){
    $('.class-stats').hide();
    $('#stat-button').on('click', function(){
      $('.class-stats').toggle();
    })
  }

// daily report ajax functions

function loadReportIndex(){
  $('.roster').on('click', 'span#loadIndex', function(event){
    var url = "/children/" + $(this).data('details') + "/daily_reports.json"
    $.getJSON(url, function(data){
      var reportList = "";
      var dataId = data[0].child_id;
      data.forEach(function(details) {
        var dailyReport = "<div class='dr><li class='rl'><a class='target' href= '/children/" + details.child_id + "/daily_reports/" + details.id + "'>" + details.date + "</a></li></div> ";
        reportList += dailyReport;
      })
      if ($('.report-area[data-details=' + dataId +']').children().length === 0) {
      $('.report-area[data-details=' + dataId +']').html(reportList);}
      else {$('.report-area[data-details=' + dataId +']').html("");};
    })
  })
}

function loadReport(){
  $('.roster').on('click', 'a.target', function(e){
    e.preventDefault();
    var newReport = $(this).closest('div')
    var url = $(this).attr('href')
    $.getJSON({url: url, locator: newReport}, function(data){})
    .done(buildDailyReport);
  });
};


function buildDailyReport(data){
  var locator = this.locator

  var report = new DailyReport(data.id, data.child_id, data.date, data.poopy_diapers, data.wet_diapers, data.bullying_report, data.ouch_report, data.kind_acts);

  report.insertIntoPage(locator);
}


function DailyReport(id, child_id, date, poopy_diapers, wet_diapers, bullying_report, ouch_report, kind_acts){
  this.id = id;
  this.child_id = child_id;
  this.date = date;
  this.poopy_diapers = poopy_diapers;
  this.wet_diapers = wet_diapers;
  this.bullying_report = bullying_report;
  this.ouch_report = ouch_report;
  this.kind_acts = kind_acts;
}


DailyReport.prototype.insertIntoPage = function(locator){
  var lineZero = "</br><hr><p> Date: " + this.date + "</p> ";
  var lineOne = "<p> Diaper Changes:</p><ul> ";
  var lineTwo = "<li> Wet Diapers: " + this.wet_diapers + "</li> ";
  var lineThree = "<li> Poopy Diapers: " + this.poopy_diapers + "</li></ul></br> ";
  if (this.bullying_report.length > 0) {
    var lineFour = "<p> Your child was a bully today: " + this.bullying_report + "</p> "} else {var lineFour = ""};
  if (this.ouch_report.length > 0) {
    var lineFive = "<p> Your child got an ouchie today: " + this.ouch_report + "</p>"} else {var lineFive = ""};
  if (this.kind_acts.length > 0) {
    var lineSix = "<p> We observed your child do something kind today: " + this.kind_acts[0].act + "</p>"} else {var lineSix = ""};
  var editLink = "<p><a href='/children/" + this.child_id + "/daily_reports/" + this.id + "/edit'>edit report</a> - "
  var deleteLink = "<span class='fake-link' id='delete-report' data-child_id='" + this.child_id + "' data-id='" + this.id +"'>delete report</span></p>"
  var template ="<div class='report'>" + lineZero + lineOne + lineTwo + lineThree + lineFour + lineFive + lineSix + editLink + deleteLink + "<hr></br></div>";
  if ($(locator).find('p').length === 0) {
    $(locator).append(template);}
  else {$(locator).find('.report').remove() }
}

function deleteReport(){
  $('.roster').on('click', 'span#delete-report', function(event){
    var choice = confirm('Do you really want to delete this record?');
    if(choice === true) {
      event.stopPropagation();
      var url = "/children/" + $(this).data('child_id') + "/daily_reports/" + $(this).data('id')
      $.ajax({url: url, type: "DELETE"})
      .done(function(success){
        $('div [data-details=' +success.id +']').parent().remove()
      });
    };
  });
};
