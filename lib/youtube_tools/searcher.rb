module YoutubeTools
	class Searcher
		attr_accessor	:term, :search_term, :href, :links
		YOUTUBE_LINK = "http://gdata.youtube.com/feeds/api/videos"
	
		def initialize(term)
			@term = term
			@search_term = url_term term
			@href = "#{YOUTUBE_LINK}?vq=#{@search_term}"
			@content = open(@href)
			@links = []
			process
		end
	
		def process
			doc = Hpricot(@content)

			@links = doc.search("//entry").collect do |entry|
				{ :title => entry.get_elements_by_tag_name("title").text, 
					:link =>  entry.get_elements_by_tag_name("link").first.get_attribute("href")
				}  		
			end
		end
		
		protected
		def url_term(term)
			term.gsub(/[ ]/, "+")
		end
	end
end
