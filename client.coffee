if Meteor.isClient

	currentRoute = (cb) -> Router.current().route.getName()

	Template.registerHelper 'showAdd', ->
		Session.get 'showAdd'

	Template.registerHelper 'editData', ->
		Session.get 'editData'

	Template.body.events
		'click #showAdd': ->
			Session.set 'showAdd', not Session.get 'showAdd'
		'click #close': ->
			Session.set 'editData', null

	Template.home.onRendered ->
		$('.parallax').parallax()

	Template.menu.onRendered ->
		$('.dropdown-button').dropdown
			constrainWidth: true
			belowOrigin: true
			hover: true

	Template.insert.helpers
		theColl: -> coll[currentRoute (res) -> res]
		theSchema: -> schema[currentRoute (res) -> res]

	Template.blog.helpers
		datas: ->
			_.map coll[currentRoute (res) -> res].find().fetch(), (item) ->
				item.text = item.text[0..300].replace /<(?:.|\n)*?>/gm, ''
				item

	Template.blog.events
		'click #remove': ->
			Meteor.call 'removePage', this._id
		'click #edit': ->
			route = currentRoute (res) -> res
			Session.set 'editData', coll[route].findOne _id: this._id

	Template.edit.helpers
		theColl: -> coll[currentRoute (res) -> res]
		theSchema: -> schema[currentRoute (res) -> res]
		data: ->
			coll[currentRoute (res) -> res].findOne()

	Template.read.helpers
		data: ->
			content = coll[currentRoute (res) -> res].findOne()
			content.date = moment(content.date).format 'dddd Do MMM YY'
			content.text = content.text.replace /<(?:.|\n)*?>/gm, ''
			content

	AutoForm.addHooks null,	after: insert: (satu, dua, tiga) ->
		console.log satu, dua, tiga

