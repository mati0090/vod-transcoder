require 'viddl-rb'

module YoutubeToWebm
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

      end

      def url_from_movie
        download_urls = ViddlRb.get_urls(video_url)
        download_urls.first
      rescue
        raise YoutubeToWebm::VideoNotFoundException
      end
  end
end
