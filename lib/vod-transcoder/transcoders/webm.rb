module VodTranscoder
  module Transcoders
    class Webm < Base

      private

        def ffmpeg_quality_flags
          "-quality good -cpu-used 0 -b:v 600k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k"
        end

        def video_codec
          'vp8'
        end

        def output_file_extension
          'webm'
        end
    end
  end
end
