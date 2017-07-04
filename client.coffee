if Meteor.isClient

	Template.home.onRendered ->
		$('.parallax').parallax()
