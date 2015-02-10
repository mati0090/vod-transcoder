require 'spec_helper'

describe VodTranscoder::Base do
  let(:video_url)         {'http://yout.be/video'}
  let(:output_file_path)  {'output/vid.webm'}
  let(:start_timespan)    {'00:00:12'}
  let(:duration)          {5}

  let(:temp_file_path)    {'tmp/file'}

  let(:file)              {double('File', :path => temp_file_path)}

  let(:webm_transcoder)   {spy('Webm')}
  let(:mp4_transcoder)    {spy('Mp4')}
  let(:downloader)        {spy('Downloader')}

  let(:base) {VodTranscoder::Base.new(:video_url        => video_url,
                                      :output_file_path => output_file_path,
                                      :start_timespan   => start_timespan,
                                      :duration         => duration) }

  before(:each) do
    allow(VodTranscoder::Downloader).to receive(:new).and_return(downloader)

    allow(webm_transcoder).to receive(:transcode!)
    allow(mp4_transcoder).to receive(:transcode!)

    allow(downloader).to receive(:download!).and_return(file)

    base.transcoders = [webm_transcoder, mp4_transcoder]
  end

  it 'should download and transcode video' do
    base.perform!

    expect(VodTranscoder::Downloader).to have_received(:new).with(video_url)

    expect(webm_transcoder).to have_received(:new).with(temp_file_path, output_file_path)
    expect(mp4_transcoder).to  have_received(:new).with(temp_file_path, output_file_path)

    expect(webm_transcoder).to have_received(:transcode!).with(start_timespan, duration)
    expect(mp4_transcoder).to  have_received(:transcode!).with(start_timespan, duration)
  end

  it 'should throw error when some required params are missing' do
    base.duration = nil

    expect{base.perform!}.to raise_error(ArgumentError)
  end
end