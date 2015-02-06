require 'streamio-ffmpeg'

module YoutubeToWebm
  class Processor

    attr_reader :video, :output_file_path

    def initialize(file_path, output_file_path)
      @video            = FFMPEG::Movie.new(file_path)
      @output_file_path = output_file_path
    end

    def transcode!(start_timestamp, duration)
      options = {
          video_codec: 'vp8',
          custom: "-ss #{start_timestamp} -t 00:00:#{format('%06.3f', duration)} -an" #-an removes audio
      }
      video.transcode(output_file_path, options)
    end

  end
end
