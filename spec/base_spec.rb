require 'spec_helper'

describe VodTranscoder::Base do
  let(:video_url)         {'http://yout.be/video'}
  let(:output_file_path)  {'output/vid.webm'}
  let(:start_timespan)    {'00:00:12'}
  let(:duration)          {5}

  let(:file)              {double('File', :path => temp_file_path)}

  let(:webm_transcoder)   {spy('Webm')}
  let(:mp4_transcoder)    {spy('Mp4')}

  let(:temp_file_path)    {'tmp/file'}
  let(:temp_file)         {tempfile_mock(temp_file_path)}

  let(:base) {VodTranscoder::Base.new(:video_url        => video_url,
                                      :output_file_path => output_file_path,
                                      :start_timespan   => start_timespan,
                                      :duration         => duration) }

  before(:each) do
    stub_file_download!

    allow(ViddlRb).to receive(:get_urls_names).and_return([{:url => 'clip_url', :name => "Movie name"}])

    allow(webm_transcoder).to receive(:transcode!)
    allow(mp4_transcoder).to  receive(:transcode!)

    allow_any_instance_of(VodTranscoder::Downloader).to receive(:temp_file).and_return(temp_file)

    base.transcoders = [webm_transcoder, mp4_transcoder]
  end

  it 'should download and transcode video' do
    base.perform!

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