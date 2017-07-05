if Meteor.isClient

	Template.home.onRendered ->
		$('.parallax').parallax()

	Template.insert.helpers
		theColl: -> pages
		theSchema: -> pageS

	Template.blog.helpers
		datas: ->
			_.map pages.find().fetch(), (item) ->
				item.text = item.text.replace /<(?:.|\n)*?>/gm, ''
				item

	Template.blog.events
		'click #remove': ->
			Meteor.call 'removePage', this._id

	Template.edit.helpers
		theColl: -> pages
		theSchema: -> pageS
		data: ->
			pages.findOne()

	Template.read.helpers
		data: ->
			content = pages.findOne()
			content.date = moment(content.date).format 'dddd Do MMM YY'
			content.text = content.text.replace /<(?:.|\n)*?>/gm, ''
			content

	AutoForm.addHooks null,	after: insert: -> Router.go '/dokumen'

