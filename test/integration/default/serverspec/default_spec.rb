require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe file('/usr/bin/virtualenvwrapper.sh') do
  it { should be_file }
end

describe file('/home/vagrant/.bashrc') do
  it { should be_file }
  its(:content) { should match /# virtualenvwrapper init/ } 
end