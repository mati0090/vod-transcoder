module YoutubeToWebm
  class Base

    attr_accessor :video_url, :output_file_path, :start_timespan, :duration

    def initialize(args={})
      @video_url        = args[:video_url]
      @output_file_path = args[:output_file_path]
      @start_timespan   = args[:start_timespan]
      @duration         = args[:duration]
    end

    def perform!
      raise ArgumentError('video_url, output_file_path, start_timespan, duration are required params!') if !video_url || !output_file_path || !start_timespan || !duration

      processor.transcode!(start_timespan, duration)
    end

    private

      def video_file_path
        downloader.download!.path
      end

      def downloader
        @downloader ||= YoutubeToWebm::Downloader.new(video_url)
      end

      def processor
        @processor ||= YoutubeToWebm::Processor.new(video_file_path ,output_file_path)
      end
  end
end
