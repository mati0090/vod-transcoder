require 'spec_helper'

describe VodTranscoder::Downloader do
  let(:youtube_clip_address) {'https://www.youtube.com/watch?v=55PrYJUEK0A'}
  let(:youtube_clip_file_url){'http://clip_directly_ulr'}

  let(:youtube_clip_data_response) {{:url => youtube_clip_file_url, :name => "Movie name"}}
  let(:y2w) {VodTranscoder::Downloader.new(youtube_clip_address)}

  before(:each) do
    allow(y2w).to receive(:save_file)
  end

  describe 'download!' do

    it 'should initiate file downloading for existing url' do
      allow(ViddlRb).to receive(:get_urls_names).and_return([youtube_clip_data_response])
      y2w.download!

      expect(y2w).to have_received(:save_file).with(youtube_clip_file_url)
    end

    it 'should trigger exception for non existing url' do
      allow(ViddlRb).to receive(:get_urls_names).and_raise(ViddlRb::DownloadError)

      expect{y2w.download!}.to raise_error(VodTranscoder::VideoNotFoundException)
    end

  end

end
