var Status = Backbone.Model.extend({

});

var Statuses = Backbone.Collection.extend({
  initialize: function(stationid) {
    this.stationid = stationid;
  },
  url: function(){
    return "/stations/" + this.stationid + "/status/search"
  },
  model: Status
});
