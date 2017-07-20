Router.configure
	layoutTemplate: 'layout'
	loadingTemplate: 'loading'

Router.route '/',
	action: -> this.render 'home'

@coll = []
@schema = []

@files = new FS.Collection 'files',
	stores: [new FS.Store.GridFS 'filesStore']
	filter:
		maxSize: 21234567
		allow: extensions: ['png', 'jpg', 'pdf']
files.allow
	insert: -> true
	update: -> true
	remove: -> true
	download: -> true
	fetch: null

makeBoth = (category) ->
	Router.route '/' + category,
		action: -> this.render 'blog'
		waitOn: -> Meteor.subscribe category
	coll[category] = new Meteor.Collection category
	coll[category].attachSchema
		title: type: String, label: 'Judul Data'
		date: type: Date, label: 'Tanggal Data'
		text: type: String, label: 'Isi Data', autoform: type: 'quill'
		files: type: [String], label: 'Lampiran', optional: true
		'files.$':
			type: String
			optional: true
			autoform:
				afFieldInput:
					type: 'fileUpload'
					collection: 'files'
	coll[category].allow
		insert: -> true
		update: -> true
		remove: -> true
	if Meteor.isServer
		Meteor.publish category, -> coll[category].find {}

makeBoth i.name for i in categories

Meteor.methods
	removePage: (category, pageId) ->
		coll[category].remove _id: pageId

	removeFile: (fileId) ->
		files.remove _id: fileId
