# Web scrapping to file important information about the design blog "Yanko Design".
# I understand "open-uri" security flaws and a lot of other things in my code that denotes that I am still a rookie programmer. Sorry for that.
# If you have any comment about my programming send me an email to mariososadi@outlook.com

require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'

class WebScrapper

  def initialize(year)
    @year = year
  end

  def url_main
    url_yanko = "https://www.yankodesign.com"
    dd = Date.ordinal(@year,@day).strftime("%d")
    mm = Date.ordinal(@year,@day).strftime("%m")
    return @url = "#{url_yanko}/#{@year}/#{mm}/#{dd}"
  end

  def url_scrapping

    for i in 1..4

      @day = i
      s = self.url_main
      url = URI.parse(s)
      request = Net::HTTP.new(url.host)
      response = request.request_head(url.path)

      if response.code.to_i != 404  # The error exception if the url/date has actually content
        html = open(s).read
        @doc = Nokogiri::HTML(html)
        links = @doc.css("#content .wrapper .entry-title a")
        @hrefs = links.map {|link| link.attribute("href").to_s}.uniq.sort.delete_if {|href| href.empty?} #Creation of the array of links of each post
      end

    end

  end

  def content_saving
      @hrefs.each do |h| 
      html = open(h).read
      @doc = Nokogiri::HTML(html)
      p text = @doc.css("p.post-without-image")
      #p @content = text.map {|link| link.inner_text.to_s}.delete_if {|href| href.empty?}
      #File.write("twitter_account.html", html_file) 

    end

  end

  
end

=begin
  def extract_tweets
    tweets = @doc.search(".js-tweet-text-container")
    dates = @doc.search(".time")
    retweets = @doc.search("[title~=Retweet] + div > span") 
    favs = @doc.search(".ProfileTweet-actionButton.js-actionButton.js-actionFavorite > div + div > span") 
    0.upto(4) do |i| 
    puts "#{dates[i].css('a').collect{|x| x["title"]}.join.split(" ",3).last.slice(0..6)}: " + "#{tweets[i].inner_text.delete!("\n").strip}" 
    puts "    Retweets: #{retweets.inner_text.split[i]}   Likes: #{favs.inner_text.split[i]}"
    end
 
  end
    
    

  def extract_stats
    twitter_stats = @doc.search(".ProfileCanopy-nav")
    twitter_stats.inner_text.split
  end

=end

 
web = WebScrapper.new(2016)
web.url_scrapping
web.content_saving

