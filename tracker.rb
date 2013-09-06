#!/usr/bin/ruby

require 'cgi'

class Tracker
	attr_reader :cgi, :imgdir

	def initialize
		@cgi = CGI.new("html4")
		@dpt_dir = '../dpt'
		@img_dir = "#{@dpt_dir}/test/"

		@cgi.out() {
			@cgi.html() {
				@cgi.body() {
					if @cgi['submit'] == 'Search'
						if not @cgi["tags"] == ""
							`rm images.list`
							images = search(CGI::unescape(@cgi["tags"]))
						
							File.open('images.list', 'w') do |listfile|
								listfile.write(images.to_s)
							end

							display(images);
						end
					elsif @cgi['submit'] == 'Show'
						images = ""

						File.open('images.list', 'r') do |listfile|
							images = listfile.read
						end

						display(images)
					elsif @cgi['submit'] == 'Refresh'
						`#{@dpt_dir}/dpt --profile=#{@img_dir} --list-tags --exec>tags_tree.xml`
						`#{@dpt_dir}/dpt --profile=#{@img_dir} --list-tags --plain>tags.list`
						
						"Tags refreshed."
					else
						"No tags given."
					end
				}
			}
		}
	end

	def search(tags)
		tags = tags.gsub(/(?=\W)/, '\\')
		images = `#{@dpt_dir}/dpt --profile=#{@img_dir} --search=#{tags}`
		
		return images;
	end

	def display(images)
		images = images.split(/\n/)
		@cgi.table() {
			rows = "";
			((images.length - 1) / 10 + 1).times do |i|
				rows += @cgi.tr('HEIGHT' => '100') {
					cols = "";
					10.times do |j|
						cols += @cgi.td('WIDTH' => '100') {
							link = "#{@img_dir}images/#{images[j + i * 10]}"
							@cgi.a('HREF' => "preview.rb?image=#{images[j + i * 10]}", 'TARGET' => 'preview_frame') {
								@cgi.img('SRC' => link, 'WIDTH' => '100', 'HEIGHT' => '100') {}
							}
						} unless i * 10 + j >= images.length
					end
					cols;
				}
			end
			rows;
		}
	end
end

Tracker.new

