require 'spec_helper'

describe VodTranscoder::Downloader do
  let(:youtube_clip_address) {'https://www.youtube.com/watch?v=55PrYJUEK0A'}
  let(:youtube_clip_file_url){'http://clip_directly_ulr'}

  let(:youtube_clip_data_response) {{:url => youtube_clip_file_url, :name => "Movie name"}}
  let(:downloader) {VodTranscoder::Downloader.new(youtube_clip_address)}

  let(:temporary_file) {tempfile_mock}

  before(:each) do
    stub_file_download!

    allow(downloader).to receive(:temp_file).and_return(temporary_file)
  end

  describe 'download!' do

    it 'should call block on success' do
      allow(ViddlRb).to receive(:get_urls_names).and_return([youtube_clip_data_response])

      expect{|block| downloader.download(&block)}.to yield_with_args(temporary_file)
    end

    it 'should close file when downloading is complete' do
      downloader.download

      expect(temporary_file).to have_received(:close)
    end

    it 'should trigger exception for non existing url' do
      allow(ViddlRb).to receive(:get_urls_names).and_raise(ViddlRb::DownloadError)

      expect{downloader.download}.to raise_error(VodTranscoder::VideoNotFoundException)
    end

  end

end
