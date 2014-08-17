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

ruby_block "insert_config" do
  block do
    Dir.foreach('/home') do |item|
      next if item == '.' or item == '..'

      file = Chef::Util::FileEdit.new("/home/#{item}/.bashrc")
      file.insert_line_if_no_match(/# virtualenvwrapper init/, "# virtualenvwrapper init")
      file.insert_line_if_no_match(/export WORKON_HOME=\/home\/#{item}\/.virtualenvs/, "export WORKON_HOME=/home/#{item}/.virtualenvs")
      file.insert_line_if_no_match(/export PROJECT_HOME=\/home\/#{item}\/Devel/, "export PROJECT_HOME=/home/#{item}/Devel")
      file.insert_line_if_no_match(/source \/usr\/bin\/virtualenvwrapper.sh/, "source /usr/bin/virtualenvwrapper.sh")
      file.write_file
    end
  end
end
