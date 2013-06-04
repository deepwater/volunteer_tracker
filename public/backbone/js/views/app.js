var app = app || {};

$(function( $ ) {
	'use strict';

	app.AppView = Backbone.View.extend({

		el: '#hushapp',

		events: {
			// 'keypress #new-todo': 'createOnEnter',
			// 'click #clear-completed': 'clearCompleted',
			// 'click #toggle-all': 'toggleAllComplete'
		},

		initialize: function() {


			app.Spots.fetch()

		},

		render: function() {

		},
	});
});
