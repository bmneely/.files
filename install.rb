#!/usr/bin/env ruby
require 'fileutils'

# Install Oh-My-Zsh
system 'sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"'

## Install NeoVundle
system "curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh > install.sh"
system "sh ./install.sh"
system "rm ./install.sh"

#Install .files
Dir.glob("*") do |file|
  next if file == '.' || file == '..' || file == ".git"
  FileUtils.copy(file.to_s, "../.#{file.to_s}")
  puts "installed .#{file}"
end
