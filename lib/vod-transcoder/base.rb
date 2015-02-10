module VodTranscoder
  class Base

    attr_accessor :video_url, :output_file_path, :start_timespan, :duration, :transcoders

    def initialize(args={})
      @video_url        = args[:video_url]
      @output_file_path = args[:output_file_path]
      @start_timespan   = args[:start_timespan]
      @duration         = args[:duration]
    end

    def perform!
      raise ArgumentError.new('video_url, output_file_path, start_timespan, duration are required params!') if !video_url || !output_file_path || !start_timespan || !duration

      perform_transcoders
    end

    private

      def video_file_path
        @video_file_path ||= downloader.download!.path
      end

      def downloader
        @downloader ||= VodTranscoder::Downloader.new(video_url)
      end

      def perform_transcoders
        transcoders.each do |transcoder|
          transcoder.new(video_file_path ,output_file_path).transcode!(start_timespan, duration)
        end
      end
  end
end
