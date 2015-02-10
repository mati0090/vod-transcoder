require 'streamio-ffmpeg'

module VodTranscoder
  class Processor

    attr_reader :video, :output_file_path

    def initialize(file_path, output_file_path)
      @video            = FFMPEG::Movie.new(file_path)
      @output_file_path = output_file_path
    end

    def transcode!(start_timestamp, duration)
      options = {
          video_codec: video_codec,
          custom:  ffmpeg_flags(start_timestamp, duration)
      }
      video.transcode(output_file_path, options)
    end

    private

      def ffmpeg_flags(start_timestamp, duration)
        "#{ffmpeg_trim_flags(start_timestamp, duration)} #{ffmpeg_quality_flags} #{ffmpeg_scale}"
      end

      def ffmpeg_trim_flags(start_timestamp, duration)
        "-ss #{start_timestamp} -t 00:00:#{format('%06.3f', duration)} -an"
      end

      def ffmpeg_quality_flags
        "-quality good -cpu-used 0 -b:v 600k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k"
      end

      def video_codec
        'vp8'
      end

      def ffmpeg_scale
        "-vf scale=600:-1"
      end

  end
end
