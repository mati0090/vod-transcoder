require 'streamio-ffmpeg'

module VodTranscoder
  module Transcoders
    class Base

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
        video.transcode(output_file_path_with_extension, options)
      end

      private

        def ffmpeg_flags(start_timestamp, duration)
          "#{ffmpeg_trim_flags(start_timestamp, duration)} #{ffmpeg_quality_flags} #{ffmpeg_scale}"
        end

        def ffmpeg_trim_flags(start_timestamp, duration)
          "-ss #{start_timestamp} -t 00:00:#{format('%06.3f', duration)} -an"
        end

        def ffmpeg_scale
          "-vf scale=600:-1"
        end

        def output_file_path_with_extension
          "#{output_file_path}.#{output_file_extension}"
        end

        def ffmpeg_quality_flags
          fail NotImplementedError
        end

        def video_codec
          fail NotImplementedError
        end

        def output_file_extension
          fail NotImplementedError
        end

    end
  end

end
