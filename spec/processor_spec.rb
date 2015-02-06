require 'spec_helper'

describe YoutubeToWebm::Processor do
  let(:file_path) {'file/path'}
  let(:output_file_path) {'output/file/path'}
  let(:start_timespan) {'00:00:15'}
  let(:duration) {10}

  let(:ffmpeg_processor) {double('FFMPEG')}

  let(:processor) {YoutubeToWebm::Processor.new(file_path, output_file_path)}

  before(:each) do
    allow(FFMPEG::Movie).to receive(:new).and_return(ffmpeg_processor)
    allow(ffmpeg_processor).to receive(:transcode)
  end

  it "should call ffmpeg processor with proper arguments" do
    processor.transcode!(start_timespan, duration)

    expect(ffmpeg_processor).to have_received(:transcode).with(output_file_path, {video_codec: 'vp8', custom: "-ss 00:00:15 -t 00:00:10.000 -an"})
  end

end
