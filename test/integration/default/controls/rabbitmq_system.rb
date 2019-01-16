control 'rabbitmq_system' do
  describe package('rabbitmq-server') do
    it { should be_installed }
  end

  describe port(5672) do
    it { should be_listening }
  end

  describe service('rabbitmq-server') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe http('http://localhost:15672') do
    its('status') { should cmp 200 }
  end
end
