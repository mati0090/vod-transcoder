def tempfile_mock(path=nil)
  double('Tempfile', :path => path, :close => true, :write => true)
end
