if Meteor.isServer

	Meteor.publish 'pages', ->
		pages.find {}
