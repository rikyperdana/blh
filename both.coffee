Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

Router.route '/dokumen',
	action: -> this.render 'blog'
	waitOn: -> Meteor.subscribe 'pages'

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

@pages = new Meteor.Collection 'pages'

@pageS = new SimpleSchema
	title: type: String, label: 'Judul Data'
	date: type: Date, label: 'Tanggal Data'
	text: type: String,	label: 'Isi Data', autoform: type: 'quill'

pages.attachSchema pageS

pages.allow
	insert: -> true
	update: -> true
	remove: -> true

Meteor.methods
	removePage: (id) ->
		pages.remove id
