[Homepage][8]

Requires Vim 7.3+ built with +ruby/dyn, Ruby and [Premailer][6].

## Usage

Open an HTML page and run `:Premailer` to get the email-friendly version.

### Parameters:

```vim
let g:premailer_options = {
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
```

* `g:premailer_options['line_length']` Line length used by to_plain_text. Boolean, default is 65.
* `g:premailer_options['link_query_string']` A string to append to every <tt>a href=""</tt> link. Do not include the initial <tt>?</tt>.
* `g:premailer_options['base_url']` Used to calculate absolute URLs for local files.
* `g:premailer_options['css']` Manually specify a CSS stylesheet.
* `g:premailer_options['css_to_attributes']` Copy related CSS attributes into HTML attributes (e.g. `background-color` to `bgcolor`)
* `g:premailer_options['css_string']` Pass CSS as a string
* `g:premailer_options['remove_ids']` Remove ID attributes whenever possible and convert IDs used as anchors to hashed to avoid collisions in webmail programs.  Default is 1.
* `g:premailer_options['remove_classes']` Remove class attributes. Default is 1.
* `g:premailer_options['remove_comments']` Remove html comments. Default is 1.
* `g:premailer_options['preserve_styles']` Whether to preserve any <tt>link rel=stylesheet</tt> and <tt>style</tt> elements.  Default is 0.
* `g:premailer_options['with_html_string']` Whether the `html` param should be treated as a raw string.
* `g:premailer_options['verbose']` Whether to print errors and warnings to <tt>$stderr</tt>.  Default is 0.

## Related plugins:

* __[prefixer.vim][2]__ » Add vendor prefixes to CSS3 properties.
* __[html_emogrifier.vim][3]__ » Convert HTML page with linked CSS to HTML email with inline CSS.
* __[cssbaseline.vim][4]__ » Build a CSS baseline (empty CSS blocks) from HTML code.
* __premailer.vim__ » Vim wrapper for the Ruby script Premailer.

[1]: http://curl.haxx.se/download.html#Win32
[2]: https://github.com/kien/prefixer.vim
[3]: https://github.com/kien/html_emogrifier.vim
[4]: https://github.com/kien/cssbaseline.vim
[5]: https://github.com/kien/premailer.vim
[6]: https://github.com/alexdunae/premailer
[7]: http://designtomarkup.com/vim/work-with-external-css-tools#premailer.vim
