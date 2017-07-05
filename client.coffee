if Meteor.isClient

	Template.home.onRendered ->
		$('.parallax').parallax()

	Template.insert.helpers
		theColl: -> pages
		theSchema: -> pageS

	Template.blog.helpers
		datas: ->
			pages.find().fetch()

	AutoForm.addHooks null,	after: insert: -> Router.go '/dokumen'

