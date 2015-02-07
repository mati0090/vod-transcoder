require 'spec_helper'

describe YoutubeToWebm::Base do
  let(:video_url)         {'http://yout.be/video'}
  let(:output_file_path)  {'output/vid.webm'}
  let(:start_timespan)    {'00:00:12'}
  let(:duration)          {5}

  let(:temp_file_path)    {'tmp/file'}

  let(:file)              {double('File', :path => temp_file_path)}

  let(:processor)         {spy('Processor')}
  let(:downloader)        {spy('Downloader')}

  let(:base) {YoutubeToWebm::Base.new(:video_url        => video_url,
                                      :output_file_path => output_file_path,
                                      :start_timespan   => start_timespan,
                                      :duration         => duration) }

  before(:each) do
    allow(YoutubeToWebm::Processor).to receive(:new) .and_return(processor)
    allow(YoutubeToWebm::Downloader).to receive(:new).and_return(downloader)

    allow(processor).to receive(:transcode!)
    allow(downloader).to receive(:download!).and_return(file)
  end

  it 'should download and transcode video' do
    base.perform!

    expect(YoutubeToWebm::Downloader).to have_received(:new).with(video_url)
    expect(YoutubeToWebm::Processor).to have_received(:new).with(temp_file_path, output_file_path)

    expect(processor).to have_received(:transcode!).with(start_timespan, duration)
  end

  it 'should throw error when some required params are missing' do
    base.duration = nil

    expect{base.perform!}.to raise_error(ArgumentError)
  end
end