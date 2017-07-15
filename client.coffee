if Meteor.isClient

	currentRoute = (cb) -> Router.current().route.getName()

	Template.registerHelper 'showAdd', -> Session.get 'showAdd'
	Template.registerHelper 'editData', -> Session.get 'editData'
	Template.registerHelper 'readData', -> Session.get 'readData'
	Template.registerHelper 'theColl', -> coll[currentRoute (res) -> res]
	Template.registerHelper 'theSchema', -> schema[currentRoute (res) -> res]
	Template.registerHelper 'loggedIn', -> true if Meteor.userId()

	Template.registerHelper 'categoryTitle', ->
		route = currentRoute (res) -> res
		objek = _.findWhere categories, name: route
		objek.title

	Template.registerHelper 'formMode', ->
		showAdd = Session.get 'showAdd'
		editData = Session.get 'editData'
		readData = Session.get 'readData'
		true if showAdd or editData or readData

	Template.body.events
		'click #showAdd': ->
			Session.set 'showAdd', true
		'click #close': ->
			Session.set 'showAdd', false
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
		userEmail: -> Meteor.user().emails[0].address
		menuProfil: -> categories[0..1]
		menuPerLing: -> categories[2..4]
		menuAmdal: -> categories[5..6]
		menuSemester: -> categories[7..14]
		menuSlhd: -> categories[15..22]
		menuDikplhd: -> categories[23..25]
		menuLak: -> categories[26..35]
		menuPeraturan: -> categories[36..43]
		menuSe: -> categories[44..47]

	Template.blog.helpers
		datas: ->
			_.map coll[currentRoute (res) -> res].find().fetch(), (item) ->
				item.text = item.text[0..300].replace /<(?:.|\n)*?>/gm, ''
				item

	Template.blog.events
		'click #edit': -> Session.set 'editData', this
		'click #read': -> Session.set 'readData', this
		'click #remove': ->
			route = currentRoute (res) -> res
			data = this
			dialog =
				message: 'Yakin hapus data?'
				title: 'Konfirmasi'
				okText: 'Ya'
				success: true
				focus: 'cancel'
			confirmRemove = new Confirmation dialog, (ok) ->
				if ok
					Meteor.call 'removePage', route, data._id
					for i in data.files
						Meteor.call 'removeFile', i

	Template.edit.helpers
		data: -> Session.get 'editData', this

	Template.read.onRendered ->
		$('.materialboxed').materialbox()

	Template.read.helpers
		data: ->
			content = Session.get 'readData'
			content.date = moment(content.date).format 'dddd Do MMM YY'
			content.text = content.text.replace /<(?:.|\n)*?>/gm, ''
			content
		files: ->
			for i in Session.get('readData').files
				Meteor.subscribe 'file', i
			files.find().fetch()

	AutoForm.addHooks null, after:
		insert: -> Session.set 'showAdd', false
		update: -> Session.set 'editData', null

	Meteor.startup ->
		AccountsEntry.config
			homeRoute: '/'
			dashboardRoute: '/'
			waitEmailVerification: false
