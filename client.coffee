if Meteor.isClient

	currentRoute = (cb) -> Router.current().route.getName()

	Template.registerHelper 'showAdd', -> Session.get 'showAdd'
	Template.registerHelper 'editData', -> Session.get 'editData'
	Template.registerHelper 'readData', -> Session.get 'readData'
	Template.registerHelper 'theColl', -> coll[currentRoute (res) -> res]
	Template.registerHelper 'theSchema', -> schema[currentRoute (res) -> res]
	Template.registerHelper 'loggedIn', -> true if Meteor.userId()

	Template.registerHelper 'category', ->
		_.findWhere categories, name: currentRoute (res) -> res

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
		menuPerLing: -> categories[0..2]
		menuAmdal: -> categories[3..3]
		menuSemester: -> categories[4..4]
		menuSlhd: -> categories[5..5]
		menuDikplhd: -> categories[6..6]
		menuLak: -> categories[7..7]
		menuPeraturan: -> categories[8..16]
		izin: -> categories[17..20]
		kinerja: -> categories[21..23]
		lapor: -> categories[24..29]
		sop: -> categories[30..33]
		aduan: -> categories[34..36]

	Template.blog.helpers
		routeIs: (name) -> Router.current().route.getName() is name
		datas: (one, two)->
			_.map coll[currentRoute (res) -> res].find().fetch(), (item) ->
				item.short = item.text[0..300].replace /<(?:.|\n)*?>/gm, ''
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
		'click #expand': (event)->
			$('.truncate').removeClass 'truncate'
			$('#expand').addClass 'hide'

	Template.edit.helpers
		data: -> Session.get 'editData'

	Template.read.onRendered ->
		$('.materialboxed').materialbox()

	Template.read.helpers
		data: ->
			content = Session.get 'readData'
			content.date = moment(content.date).format 'dddd Do MMM YY'
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
