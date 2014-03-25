google.load("visualization", "1", {packages:["annotatedtimeline"]});
google.setOnLoadCallback(load_data);

function draw_chart(status_data, total_docks){
  drawChart();
      function drawChart() {
        var dataTable = new google.visualization.DataTable();
        dataTable.addColumn('datetime', 'Time');
        dataTable.addColumn('number', 'Available Bikes');
        dataTable.addRows(status_data);

        var dataView = new google.visualization.DataView(dataTable);
        var options = {
          title: 'Company Performance',
          max: total_docks
        };
        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('chart_div'));
        chart.draw(dataView, options);
      }
}

function load_data(){

var stationId = 286;
var statuses = new Statuses(stationId);
var station = new Station({id: stationId});
  total_docks = 0;
  chart_statuses = new Array;

 $.when(
  station.fetch(),
  statuses.fetch()
  ).then( 
function(){

  total_docks = station.get('total_docks');

  chart_statuses = statuses.map(function(status) {
        var d = new Date(status.get("created_at"));
        var centralOffset = 6*60*60*1000;
        var timeZoneDate = new Date(d.getTime() + (d.getTimezoneOffset() * 60000) ); // redefine variable
      
        return [timeZoneDate, status.get("available_bikes")];
    });
    
    var d = new Date("2014-01-20T12:48:02.000Z");
    var centralOffset = 6*60*60*1000;

    timeZoneDate = new Date(d.getTime() + (d.getTimezoneOffset() * 60000) ); // redefine variable

    draw_chart(chart_statuses, total_docks);
}



);
}

