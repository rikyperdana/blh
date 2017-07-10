Router.configure
	layoutTemplate: 'layout'
	loadingTemplate: 'loading'

Router.route '/',
	action: -> this.render 'home'

@categories = [
	name: 'struktur', title: 'Struktur Organisasi'
,
	name: 'tupoksi', title: 'Tugas dan Fungsi'
,
	name: 'dddtlh', title: 'Daya Dukung dan Daya Tampung Lingkungan Hidup (DDDTHL)'
,
	name: 'rpplh', title: 'Rencana Perlindungan dan Pengelolaan Lingkungan Hidup (RPPLH)'
,
	name: 'klhs', title: 'Kajian Lingkungan Hidup Strategis (KLHS)'
,
	name: 'dpilkp', title: 'Daftar Penerbitan Izin Lingkungan (Kewenangan Provinsi)'
,
	name: 'ppkp', title: 'Profil Pemrakarsa (Kewenangan Provinsi)'
,
	name: 's1-2016', title: 'Semester I 2016'
,
	name: 's2-2016', title: 'Semester II 2016'
,
	name: 's1-2017', title: 'Semester I 2017'
,
	name: 's2-2017', title: 'Semester II 2017'
,
	name: 's1-2018', title: 'Semester I 2018'
,
	name: 's2-2018', title: 'Semester II 2018'
,
	name: 's1-2019', title: 'Semester I 2019'
,
	name: 's2-2019', title: 'Semester II 2019'
,
	name: 'slhd2009', title: 'SLHD 2009'
,
	name: 'slhd2010', title: 'SLHD 2010'
,
	name: 'slhd2011', title: 'SLHD 2011'
,
	name: 'slhd2012', title: 'SLHD 2012'
,
	name: 'slhd2013', title: 'SLHD 2013'
,
	name: 'slhd2014', title: 'SLHD 2014'
,
	name: 'slhd2015', title: 'SLHD 2015'
,
	name: 'slhd2016', title: 'SLHD 2016'
,
	name: 'dikplhd2017', title: 'DIKPLHD Tahun 2017'
,
	name: 'dikplhd2018', title: 'DIKPLHD Tahun 2018'
,
	name: 'dikplhd2019', title: 'DIKPLHD Tahun 2019'
,
	name: 'lakprpplh2017', title: 'Laporan Akhir Kegiatan Penyusunan Rencana Perlindungan dan Pengelolaan Lingkungan Hidup (RPPLH) Riau (2017)'
,
	name: 'lakaklhskab2017', title: 'Laporan Akhir Kegiatan Asistensi KLHS Kabupaten/Kota (2017)'
,
	name: 'lakpppamdal2017', title: 'Laporan Akhir Kegiatan Penilaian, Pembinaan dan Pengawasan AMDAL (2017)'
,
	name: 'lakpslhdbslhd2017', title: 'Laporan Akhir Kegiatan Penyusunan Status Lingkungan Hidup Daerah dan Buku Statistik Lingkungan Hidup Daerah (2017)'
,
	name: 'lakppklh2017', title: 'Laporan Akhir Kegiatan Penataan dan Penanganan Kasus Lingkungan Hidup (2017)'
,
	name: 'lakpppktpk2017', title: 'Laporan Akhir Kegiatan Penanganan dan Penyelesaian Perkara/Kasus Tindak Pidana Kehutanan (2017)'
,
	name: 'lakoptpk2017', title: 'Laporan Akhir Kegiatan Operasi Pemberantasan Tindak Pidana Kehutanan (2017)'
,
	name: 'lakpspspkppns2017', title: 'Laporan Akhir Kegiatan Pengadaan Sarana dan Prasarana Satuan Polisi Kehutanan dan PPNS (2017)'
,
	name: 'pkl', title: 'Pengaduan Kasus Lingkungan'
,
	name: 'phl', title: 'Penegakan Hukum Lingkungan'
,
	name: 'uu', title: 'Undang-undang'
,
	name: 'permen', title: 'Peraturan Menteri'
,
	name: 'perpres', title: 'Peraturan Presiden'
,
	name: 'kepres', title: 'Keputusan Presiden'
,
	name: 'perda', title: 'Peraturan Daerah'
,
	name: 'pergub', title: 'Peraturan Gubernur'
,
	name: 'kepgub', title: 'Keputusan Gubernur'
,
	name: 'semen', title: 'Surat Edaran Menteri'
,
	name: 'segub', title: 'Surat Edaran Gubernur'
,
	name: 'kak', title: 'Kerangka Acuan Kerja'
,
	name: 'sop', title: 'Standar Operasional Prosedur'
]

@coll = []
@schema = []

@files = new FS.Collection 'files',
	stores: [new FS.Store.GridFS 'filesStore']
	filter:
		maxSize: 1048576
		allow: extensions: ['png']
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
		fileId:
			type: String
			optional: true
			autoform:
				afFieldInput:
					type: 'cfs-file'
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
