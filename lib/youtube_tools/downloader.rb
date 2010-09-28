module YoutubeTools
	class Downloader
		attr_accessor	:href, :name, :full_path, :content, :link_dw, :percent, :total
	
		LINK_PATTERN = /"fmt_stream_map": ("[\w |:\/\\.?=&\,%-]+")/
		NAME_PATTERN = /-\s+(.*)\s*/
	
		def initialize(href, path=nil)
			@href = href
			@music_folder = path.nil? ? FOLDER_PATH : path

			create_folder
			init_information	
		end
		
		def name
			@name ||= search_name(@doc.search("//title").first)
		end
		
		def link_dw
			@link_dw ||= search_link(@doc.search("//script")[8].to_plain_text)
		end
		
		def full_path
			@full_path ||= File.join(@music_folder, name.split("/").last)
		end
				
		# method dowload video from selected folder
		def download_video
			@percent = @total = 0
			print "Downloading...0%"
			open(@full_path, 'wb') do |file|
				file.write(open(@link_dw, :content_length_proc => lambda {|t|
			 			if t && 0 < t
					 		@total = t        
				 		end
					}, :progress_proc => lambda {|s|
						old_percent = @percent
						@percent = (s * 100)/@total
						print "..#{@percent}%" if @percent != old_percent
					}).read)
			end
		end
		
		protected
		def init_information
			@content = open(@href)
			@doc = Hpricot(@content)
			@name = search_name(@doc.search("//title").first)
			@link_dw = search_link(@doc.search("//script")[8].to_plain_text)
			@full_path = File.join(@music_folder, name.split("/").last)
		end
		
		# method fo search link to download video 
		# values for type :
		# 5 = low quality
		# 18 = mid quality (mp4)
		# 22 = HD quality 
		# 34 or 4 = mid quality
		# 35 = hight quality
		def search_link(link_dw, type=5)
			url_pattern = /,#{type}\|(http[^\|]+)(?:\|.*)?$/
			link = link_dw.gsub(LINK_PATTERN).first
			link = link[19...link.length]
			link = link.gsub(url_pattern).first
			link = link.gsub(/[\\,"]/, "").gsub(/(\|\|.*)/, "")
			link[2..link.length]		
		end
		
		# method for search name for video
		def search_name(content)
			name = content.to_plain_text.gsub(NAME_PATTERN).first
			name = name[1..name.length].gsub(/[\n\s()`'"\/,;<>?!&%$@*+=.]/, "")
			name[0..name.length-1]
		end
		
		# method create folder case not exist
		def create_folder
			#create folder if no exist
			unless File.exist? @music_folder
				puts "Creating #{@music_folder}"
				FileUtils.mkdir_p(@music_folder)
			end
		end
	end
end
