require 'viddl-rb'
require 'typhoeus'

module VodTranscoder
  class Downloader
    attr_reader :video_url

    def initialize(video_url)
      @video_url = video_url
    end

    def download!
      save_file(url_from_movie)
    end

    private

      def save_file(file_url)
        downloaded_file = File.open temp_file_path, 'wb'
        request = Typhoeus::Request.new(file_url, headers: headers, verbose: true, follow_location: true)
        request.on_headers do |response|
          if response.code != 200
            raise VodTranscoder::VideoNotFoundException
          end
        end
        request.on_body do |chunk|
          downloaded_file.write(chunk)
        end
        request.on_complete do
          downloaded_file.close
        end
        request.run

        downloaded_file
      end

      def url_from_movie
        download_urls = ViddlRb.get_urls(video_url)
        download_urls.first
      rescue
        raise VodTranscoder::VideoNotFoundException
      end

      def video_id
        uri = URI(video_url)
        params = CGI.parse(uri.query)
        params['v'].first
      end

      def temp_file_path
        "tmp/#{video_id}"
      end

      def headers
        { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.168 Safari/535.19",
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip,deflate,sdch",
          "Accept-Language" => "en-US,en;q=0.8,pl;q=0.6"}
      end
  end
end
