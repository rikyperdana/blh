Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

Router.route '/halaman',
	action: -> this.render 'page'

Router.route '/insert',
	action: -> this.render 'insert'

Router.route '/edit/:id',
	action: -> this.render 'edit'
	waitOn: -> Meteor.subscribe 'page', this.params.id

Router.route '/read/:id',
	action: -> this.render 'read'
	waitOn: -> Meteor.subscribe 'page', this.params.id

@categories = ['pages', 'rpplh', 'klhs', 'slhd', 'pengaduan', 'amdal', 'uklupl', 'perizinan']
@coll = []
@schema = []

makeBoth = (category) ->
	Router.route '/' + category,
		action: -> this.render 'blog'
		waitOn: -> Meteor.subscribe category
	coll[category] = new Meteor.Collection category
	coll[category].attachSchema
		title: type: String, label: 'Judul Data'
		date: type: Date, label: 'Tanggal Data'
		text: type: String, label: 'Isi Data', autoform: type: 'quill'
	coll[category].allow
		insert: -> true
		update: -> true
		remove: -> true
	if Meteor.isServer
		Meteor.publish category, -> coll[category].find {}

makeBoth i for i in categories

@files = new Meteor.Collection 'files',
	stores: [new FS.Store.GridFS 'filesStore']
	filter:
		maxSize: 1048576
		allow: extensions: ['png']
files.allow
	insert: -> true
	update: -> true
	remove: -> true
	fetch: null

Meteor.methods
	removePage: (category, pageId) ->
		coll[category].remove _id: pageId
