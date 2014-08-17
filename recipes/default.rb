#
# Cookbook Name:: virtualenv
# Recipe:: default
#
# Copyright (C) 2014 Patrick Ayoup
#
# MIT License
#

include_recipe "python"

python_pip "virtualenvwrapper" do
  action :upgrade
  version node['python']['virtualenvwrapper_version']
end

# Add the configuration script to .bashrc on all users.
node['etc']['passwd'].each do |user, data|

  ruby_block "insert_config" do
    block do
      file = Chef::Util::FileEdit.new("#{data['dir']}/.bashrc")
      file.insert_line_if_no_match(/# virtualenvwrapper init/, "# virtualenvwrapper init")
      file.insert_line_if_no_match(/export WORKON_HOME=#{data['dir']}\/.virtualenvs/, "export WORKON_HOME=#{data['dir']}/.virtualenvs")
      file.insert_line_if_no_match(/export PROJECT_HOME=#{data['dir']}\/Devel/, "export PROJECT_HOME=#{data['dir']}/Devel")
      file.insert_line_if_no_match(/source \/usr\/bin\/virtualenvwrapper.sh/, "source /usr/bin/virtualenvwrapper.sh")
      file.write_file
    end
    only_if { data['dir'].include? '/home/' }
  end
end
