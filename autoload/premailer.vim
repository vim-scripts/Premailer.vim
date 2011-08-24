" ============================================================
" File:          premailer.vim
" Description:   Interface with the ruby script Premailer
" Author:        Kien Nguyen <info@designtomarkup.com>
" License:       MIT
" Repository:    https://github.com/kien/premailer.vim
" ============================================================

let s:save_cpo = &cpo
set cpo&vim

" ==== Options
" [+line_length+] Line length used by to_plain_text. Boolean, default is 65.
" [+link_query_string+] A string to append to every <tt>a href=""</tt> link.
"     Do not include the initial <tt>?</tt>.
" [+base_url+] Used to calculate absolute URLs for local files.
" [+css+] Manually specify a CSS stylesheet.
" [+css_to_attributes+] Copy related CSS attributes into HTML attributes
"     (e.g. +background-color+ to +bgcolor+)
" [+css_string+] Pass CSS as a string
" [+remove_ids+] Remove ID attributes whenever possible and convert IDs used
"     as anchors to hashed to avoid collisions in webmail programs.
"     Default is 0.
" [+remove_classes+] Remove class attributes. Default is 0.
" [+remove_comments+] Remove html comments. Default is 0.
" [+preserve_styles+] Whether to preserve any <tt>link rel=stylesheet</tt>
"     and <tt>style</tt> elements.  Default is 0.
" [+with_html_string+] Whether the +html+ param should be treated as a raw
"     string.
" [+verbose+] Whether to print errors and warnings to <tt>$stderr</tt>.
"     Default is 0.

if !exists('g:premailer_options')
	let s:premopt = {
				\ 'line_length': 65,
				\ 'link_query_string': '',
				\ 'base_url': '',
				\ 'remove_classes': 1,
				\ 'remove_ids': 1,
				\ 'remove_comments': 1,
				\ 'css': [],
				\ 'css_to_attributes': 1,
				\ 'with_html_string': 0,
				\ 'css_string': '',
				\ 'preserve_styles': 0,
				\ 'verbose': 0,
				\ }
else
	let s:premopt = g:premailer_options
	unlet g:premailer_options
endif

func! premailer#init(...)

	if !executable('ruby') || !executable('gem') || !executable('premailer')
		echohl Error
		echo 'This plugin requires RubyGems and Premailer.'
		echohl None
		retu
	endif

	for key in keys(s:premopt)
		if empty(s:premopt[key])
			cal remove(s:premopt, key)
			con
		endif
		exe 'let '.key.' = "'.escape(string(s:premopt[key]), "\\").'"'
	endfor

	let htmlfile = expand('%:p')
	let outhtml = expand('%:p:r').'-email.'.expand('%:e')
	let outtxt = expand('%:p:r').'.txt'

	if !exists('a:1')
		let html = 1
	else
		let html = a:1
	endif

	if !exists('a:2')
		let txt = 0
	else
		let txt = a:2
	endif

	if !exists('a:3')
		let warnings = 0
	else
		let warnings = a:3
	endif

ruby << EOF
	def init
		require 'rubygems'
		require 'premailer'
		$premailer = Premailer.new(
			get_string('htmlfile'), {
			:warn_level        => Premailer::Warnings::SAFE,
			:line_length       => get_number('line_length'),
			:link_query_string => get_string('link_query_string'),
			:base_url          => get_string('base_url'),
			:remove_classes    => get_bool('remove_classes'),
			:remove_ids        => get_bool('remove_ids'),
			:remove_comments   => get_bool('remove_comments'),
			:css               => get_array('css'),
			:css_to_attributes => get_bool('css_to_attributes'),
			:with_html_string  => get_bool('with_html_string'),
			:css_string        => get_string('css_string'),
			:preserve_styles   => get_bool('preserve_styles'),
			:verbose           => get_bool('verbose'),
			}
		)
	end

	def exists? name
		::VIM::evaluate("exists(\"#{name}\")").to_i != 0
	end

	def get_number name
		exists?(name) ? ::VIM::evaluate("#{name}").to_i : nil
	end

	def get_bool name
		exists?(name) ? ::VIM::evaluate("#{name}").to_i != 0 : nil
	end

	def get_string name
		exists?(name) ? ::VIM::evaluate("#{name}").to_s : nil
	end

	def get_array name
		exists?(name) ? eval(::VIM::evaluate("#{name}").to_s) : []
	end

	# Write the HTML output
	def html_out
		$fout = File.open(get_string('outhtml'), "w")
		$fout.puts $premailer.to_inline_css
		$fout.close
	end

	# Write the plain-text output
	def txt_out
		$fout = File.open(get_string('outtxt'), "w")
		$fout.puts $premailer.to_plain_text
		$fout.close
	end

	# Output any CSS warnings
	def css_warns
		$premailer.warnings.each do |w|
		puts "#{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
		end
	end
EOF

	if html != 0
ruby << EOF
		init
		html_out
EOF
	endif
	if txt != 0
ruby << EOF
		init
		txt_out
EOF
	endif
	if warnings != 0
ruby << EOF
		init
		css_warns
EOF
	endif

	if filereadable(outhtml)
		exe 'sil! to vne '.outhtml
	endif

	if filereadable(outtxt)
		exe 'sil! to vne '.outtxt
	endif

endfunc

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:nofen:noet:ts=2:sw=2:sts=2
