require 'helper'

describe YoutubeTools do
	before do
		@term = "Bon Jovi"
		@search_term = "Bon+Jovi"
		@href = "http://www.youtube.com/watch?v=vx2u5uUu3DE&feature=youtube_gdata"
		@yapi = "http://gdata.youtube.com/feeds/api/videos?vq="
		@title = "Bon Jovi - It's My Life"
		@file_name = "BonJovi-ItsMyLife"
		@path = File.join(ENV['HOME'],"/Musica/RTubeToMp3")
	end
	
	describe "when search a video" do
		before do
			@yts = YoutubeTools::Searcher.new @term
		end
		
		it "should have a search name and href" do
			@yts.search_term.must_equal @search_term
			@yts.href.must_equal "#{@yapi}#{@search_term}"		
		end
		
		it "should have not empty links and included link" do
			@yts.links.wont_be_empty
			link = {:title=>@title, :link=>@href}
			@yts.links.must_include link
		end
	end
	
	describe "when download and converter a video" do
		before do
			@ytd = YoutubeTools::Downloader.new @href		
		end
		
		it "should have music path and name" do
			@ytd.name.must_equal @file_name
			@ytd.full_path.must_equal "#{@path}/#{@file_name}"
			ytd = YoutubeTools::Downloader.new @href, "/home/maykon/Musica"
			ytd.full_path.must_equal "/home/maykon/Musica/#{@file_name}"
		end
		
		it "should have download file and converter video" do
			@ytd.link_dw.wont_be_nil
			@ytd.link_dw.must_match /(http[^\|]+)(?:\|.*)?$/
			@ytd.download_video
			File.exist?(@ytd.full_path).must_equal true

			## converter video
			@ytc = YoutubeTools::Converter.new @file_name
			@ytc.file_name.must_equal "#{@path}/#{@file_name}.mp3"
			File.exist?(@ytc.file_name).must_equal true
			File.exist?(@ytc.file).wont_equal true
		end
	end
end
