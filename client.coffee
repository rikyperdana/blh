if Meteor.isClient

	currentRoute = (cb) -> Router.current().route.getName()

	Template.registerHelper 'showAdd', ->
		Session.get 'showAdd'

	Template.registerHelper 'editData', ->
		Session.get 'editData'

	Template.registerHelper 'readData', ->
		Session.get 'readData'

	Template.registerHelper 'title', ->
		route = currentRoute (res) -> res
		route.toUpperCase()

	Template.registerHelper 'formMode', ->
		showAdd = Session.get 'showAdd'
		editData = Session.get 'editData'
		readData = Session.get 'readData'
		true if showAdd or editData or readData

	Template.body.events
		'click #showAdd': ->
			Session.set 'showAdd', not Session.get 'showAdd'
		'click #close': ->
			Session.set 'editData', null
			Session.set 'readData', null

	Template.home.onRendered ->
		$('.parallax').parallax()

	Template.menu.onRendered ->
		$('.dropdown-button').dropdown
			constrainWidth: true
			belowOrigin: true
			hover: true

	Template.menu.helpers
		loggedIn: ->
			true if Meteor.userId()
		userEmail: ->
			Meteor.user().emails[0].address

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
			route = currentRoute (res) -> res
			Meteor.call 'removePage', route, this._id
		'click #edit': ->
			route = currentRoute (res) -> res
			Session.set 'editData', coll[route].findOne _id: this._id
		'click #read': ->
			route = currentRoute (res) -> res
			Session.set 'readData', coll[route].findOne _id: this._id

	Template.edit.helpers
		theColl: -> coll[currentRoute (res) -> res]
		theSchema: -> schema[currentRoute (res) -> res]
		data: ->
			coll[currentRoute (res) -> res].findOne()

	Template.read.onRendered ->
		$('.materialboxed').materialbox()

	Template.read.helpers
		data: ->
			content = coll[currentRoute (res) -> res].findOne()
			content.date = moment(content.date).format 'dddd Do MMM YY'
			content.text = content.text.replace /<(?:.|\n)*?>/gm, ''
			content
		file: ->
			Meteor.subscribe 'file', Session.get('readData').fileId
			files.findOne()

	AutoForm.addHooks null, after: insert: ->
		Session.set 'showAdd', false

	Meteor.startup ->
		AccountsEntry.config
			homeRoute: '/'
			dashboardRoute: '/'
			waitEmailVerification: false
