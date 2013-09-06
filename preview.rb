#!/usr/bin/ruby

require 'cgi'

class Preview
	def initialize
		@cgi = CGI.new('html4')
		@dpt_dir = '../dpt'
		@img_dir = "#{@dpt_dir}/test/images/"

		if @cgi.has_key?('image')
			preview_image(@img_dir + @cgi['image'])
		else
			error_exit
		end
	end

	def preview_image(image)
		@cgi.out() {
			@cgi.html() {
				index = image.gsub(/\A[^\d]+/, '').gsub(/[^\d]+\Z/, '')

				@cgi.img('SRC' => image, 'WIDTH' => '100%', 'STYLE' => 'max-height:300px;') {} +
				@cgi.p() {
					tag_list(index)
				}
			}
		}
	end

	def tag_list(index)
		list = `#{@dpt_dir}/dpt --profile=#{@dpt_dir}/test --list-images --image=#{index}`
		result = ""

		list.split(/\n/).each do |line|
			link = ''
			path = ''
			
			line[1..-1].split(/\./).each do |tag|
				path += '.' + tag
				link += @cgi.a('HREF' => "tracker.rb?submit=Search&tags=#{path}", 'TARGET' => 'tracker_frame') { ".#{tag}" }
			end

			result += link + '<br />'
		end

		return result
	end

	def error_exit
		@cgi.out() {
			@cgi.html() {
				"None"
			}
		}
	end
end

Preview.new

