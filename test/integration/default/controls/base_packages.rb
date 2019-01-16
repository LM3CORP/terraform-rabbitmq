
control 'base_packages' do
  describe package('bzip2') do
    it { should be_installed }
  end
end
