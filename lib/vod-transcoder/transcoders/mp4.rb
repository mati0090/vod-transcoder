module VodTranscoder
  module Transcoders
    class Mp4 < Base

      private

        def ffmpeg_quality_flags
          "-vprofile high -b:v 500k -maxrate 500k -bufsize 1000k"
        end

        def video_codec
          'libx264'
        end

        def output_file_extension
          'mp4'
        end
    end
  end
end
