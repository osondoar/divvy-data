var Station = Backbone.Model.extend({
  initialize: function(){
  },
  urlRoot: "/stations/"
});

var Stations = Backbone.Collection.extend({
  initialize: function(model, id) {
  },
  url: "/stations/",
  model: Station
});
