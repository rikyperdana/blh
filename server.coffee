if Meteor.isServer

	Meteor.publish 'pages', ->
		pages.find {}

	Meteor.publish 'page', (id) ->
		pages.find {}

	Meteor.publish 'file', (id) ->
		files.find _id: id
