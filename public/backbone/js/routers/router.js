// var app = app || {};

// (function() {
// 	'use strict';

// 	// Todo Router
// 	// ----------

// 	var Workspace = Backbone.Router.extend({
// 		routes:{
// 			'*filter': 'setFilter'
// 		},

// 		setFilter: function( param ) {
// 			// Set the current filter to be used
// 			app.SpotFilter = param.trim() || '';

// 			// Trigger a collection filter event, causing hiding/unhiding
// 			// of Todo view items
// 			app.Spots.trigger('filter');
// 		}
// 	});

// 	app.SpotRouter = new Workspace();
// 	Backbone.history.start();

// }());
