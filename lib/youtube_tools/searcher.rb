module YoutubeTools
	class Searcher
		attr_accessor	:term, :search_term, :href, :links, :order_by, :start_index, :max_results

		ORDER_BY = %w(relevance published viewCount rating)
		YOUTUBE_LINK = "http://gdata.youtube.com/feeds/api/videos"
	
		def initialize(term, options={})
			@term = term
			@search_term = url_term term			
			@order_by = options[:order_by].nil? ? set_order(0) : set_order(options[:order_by])
			@start_index = options[:start_index].nil? ? 0 : set_start(options[:start_index])
			@max_results = options[:max_results].nil? ? 10 : set_max(options[:max_results])
			@href = make_url
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
		
		def set_order(index)
			return ORDER_BY[index] if index > 0 && index < 4
			ORDER_BY[0]
		end
		
		def set_start(val)
			return val if val >= 0
			0
		end
		
		def set_max(max)
			return max if max > 0 && max <= 50
			10
		end
		
		protected
		def make_url
			href = "#{YOUTUBE_LINK}?vq=#{@search_term}"
			href << "&orderby=#{@order_by}" if @order_by != ORDER_BY[0]
    	href << "&start-index=#{@start_index}" if @start_index > 0
    	href << "&max-results=#{@max_results}" if @max_results != 10
			href
		end
		
		def url_term(term)
			CHARACTERS.each do |char, val|
				puts "#{char}: #{val}"
				term.gsub!(/[#{char}]/, val)
			end
			term
		end
	end
end
