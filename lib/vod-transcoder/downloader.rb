require 'viddl-rb'
require 'typhoeus'

module VodTranscoder
  class Downloader
    attr_reader :video_url

    def initialize(video_url)
      @video_url = video_url
    end

    def download
      request = Typhoeus::Request.new(movie_url, headers: headers, verbose: true, follow_location: true)
      request.on_headers do |response|
        if response.code != 200
          raise VodTranscoder::VideoNotFoundException
        end
      end
      request.on_body do |chunk|
        temp_file.write(chunk)
      end
      request.on_complete do
        temp_file.close

        yield(temp_file) if block_given?
      end
      request.run

      temp_file
    end

    private

      def movie_data
        @movie_data ||= ViddlRb.get_urls_names(video_url).first
      rescue ViddlRb::DownloadError
        raise VodTranscoder::VideoNotFoundException
      end

      def movie_url
        movie_data[:url]
      end

      def movie_name
        movie_data[:name]
      end

      def temp_file_name
        movie_name
      end

      def temp_file
        @temp_file ||= Tempfile.new(temp_file_name)
      end

      def headers
        { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.168 Safari/535.19",
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip,deflate,sdch",
          "Accept-Language" => "en-US,en;q=0.8,pl;q=0.6"}
      end
  end
end
