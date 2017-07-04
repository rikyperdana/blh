Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'home'

Router.route '/dokumen',
	action: -> this.render 'blog'

Router.route '/halaman',
	action: -> this.render 'page'
