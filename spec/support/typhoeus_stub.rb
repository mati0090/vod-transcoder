RSpec.configure do |config|
  config.before :each do
    Typhoeus::Expectation.clear
  end
end

def stub_file_download!
  res = Typhoeus::Response.new code: 200, body: '', headers: {}
  Typhoeus.stub(//).and_return res
end
