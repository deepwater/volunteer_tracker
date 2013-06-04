var app = app || {};

$(function() {
	'use strict';

	// Todo Item View
	// --------------

	// The DOM element for a todo item...
	app.SpotView = Backbone.View.extend({

		//... is a list tag.
		tagName:  'li',

		// Cache the template function for a single item.
		template: _.template( $('#item-template').html() ),

		// The DOM events specific to an item.
		events: {
			'click':	'toggleCompleted'
		},

		// The TodoView listens for changes to its model, re-rendering. Since there's
		// a one-to-one correspondence between a **Todo** and a **TodoView** in this
		// app, we set a direct reference on the model for convenience.
		initialize: function() {
			this.listenTo(this.model, 'change', this.render);
			this.listenTo(this.model, 'destroy', this.remove);
			this.listenTo(this.model, 'visible', this.toggleVisible);
		},

		// Re-render the titles of the todo item.
		render: function() {
			this.$el.html( this.template( this.model.toJSON() ) );
			return this;
		},

		// Remove the item, destroy the model from *localStorage* and delete its view.
		clear: function() {
			this.model.destroy();
		}
	});
});
