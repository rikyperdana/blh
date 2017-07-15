if Meteor.isServer

	Meteor.publish 'pages', -> pages.find {}

	Meteor.publish 'files', (id) -> files.find _id: id
