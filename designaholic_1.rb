# Web scrapping to file important information about the design blog "designaholic.mx".
# I understand "open-uri" security flaws and a lot of other things in my code that denotes that I am still a novice programmer. Sorry for that.
# If you have any comment about my programming send me an email to mariososadi@outlook.com

require 'nokogiri'
require 'open-uri'
require 'date'
require 'net/http'
require 'benchmark'
require 'openssl'

class WebScrapper

  def initialize(year)
    @year = year
  end

  def url_main
    url_des = "http://www.designaholic.mx"
    dd = Date.ordinal(@year,@day).strftime("%d")
    mm = Date.ordinal(@year,@day).strftime("%m")
    return @url = "#{url_des}/#{@year}/#{mm}/#{dd}/"
  end

  def url_scrapping

    for i in 1..366

      @day = i
      s = self.url_main
      url = URI.parse(s)
      request = Net::HTTP.new(url.host)
      response = request.request_head(url.path)

     # p request.verify_mode = OpenSSL::SSL::VERIFY_PEER
     # p request.use_ssl = true
     # p request.ssl_version = :TLSv1



    
   
      # Dealing with redirectionings because...well...internet
      if response.code == "301"
        response = Net::HTTP.get_response(URI.parse(response.header['location']))
      end

      
      #      prev_setting = OpenSSL::SSL.send(:remove_const, :VERIFY_PEER)
      # OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)

      #   # do my connnection thang!
      # OpenSSL::SSL.send(:remove_const, :VERIFY_PEER)
      # OpenSSL::SSL.const_set(:VERIFY_PEER, prev_setting)

   

      if response.code.to_i != 404  # The error exception if the url/date has actually content
        html = open(s).read
        @doc = Nokogiri::HTML(html)
        links = @doc.css("div.three.columns.articulo.video a, div.three.columns.articulo a")
        @hrefs = links.map {|link| link.attribute("href").to_s}.uniq.sort.delete_if {|href| href.empty?} # Creation of the array of links of each post
        self.content_saving
      end

    end

  # def get_response_with_redirect(uri)
  #       r = Net::HTTP.get_response(uri)
         
  #       r
  #     end

  end

  def content_saving

    @hrefs.each do |h| 
      html = open(h).read
      @doc = Nokogiri::HTML(html)
      text = @doc.css("article.cuerpo_post.eight.columns p")
      @content = text.map {|t| t.inner_text.to_s.strip}.delete_if {|t| t.empty? || t=="Más info" }
      @content.shift
      3.times{@content.pop }
      File.open('context.txt', 'a') { |f| f.puts @content.join(" ") }
    end

  end

  
end

web = WebScrapper.new(2016)
web.url_scrapping


