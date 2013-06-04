var app = app || {};

(function() {
	'use strict';

	var SpotList = Backbone.Collection.extend({

		model: app.Spot,
		url: 'http:/localhost:3000/tasks'

	});

	// Create our global collection of **Todos**.
	app.Spots = new SpotList();

}());
