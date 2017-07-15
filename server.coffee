if Meteor.isServer

	Meteor.publish 'pages', -> pages.find {}

	Meteor.publish 'file', (id) -> files.find _id: id
