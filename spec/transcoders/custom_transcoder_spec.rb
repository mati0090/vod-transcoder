require 'spec_helper'

class CustomTranscoder < VodTranscoder::Transcoders::Base

  private

    def ffmpeg_quality_flags
      "-quality good -cpu-used 0 -b:v 600k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k"
    end

    def video_codec
      'vp8'
    end

end

describe VodTranscoder::Transcoders::Base do
  let(:file_path) {'file/path'}
  let(:output_file_path) {'output/file/path'}
  let(:start_timespan) {'00:00:15'}
  let(:duration) {10}

  let(:ffmpeg_processor) {double('FFMPEG')}

  let(:processor) {CustomTranscoder.new(file_path, output_file_path)}

  before(:each) do
    allow(FFMPEG::Movie).to receive(:new).and_return(ffmpeg_processor)
    allow(ffmpeg_processor).to receive(:transcode)
  end

  it "should call ffmpeg processor with proper arguments" do
    processor.transcode!(start_timespan, duration)

    #standard arguments
    expect(ffmpeg_processor).to have_received(:transcode).with(output_file_path, {video_codec: 'vp8', custom: /-ss 00:00:15 -t 00:00:10.000 -an/})

    #custom arguments
    expect(ffmpeg_processor).to have_received(:transcode).with(output_file_path, {video_codec: 'vp8', custom: /-quality good -cpu-used 0 -b:v 600k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k/})
  end

end
