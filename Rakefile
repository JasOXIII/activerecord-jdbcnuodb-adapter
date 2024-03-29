#
# Copyright (c) 2012 - 2013, NuoDB, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of NuoDB, Inc. nor the names of its contributors may
#       be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL NUODB, INC. BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'date'

require 'bundler'
require 'bundler/gem_tasks'

require File.expand_path(File.dirname(__FILE__)) + '/spec/support/config'
require File.expand_path(File.dirname(__FILE__)) + '/tasks/rspec'

Bundler::GemHelper.install_tasks

load 'activerecord-jdbcnuodb-adapter.gemspec'

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  require File.expand_path('../lib/activerecord-jdbcnuodb-adapter', __FILE__)
  ArJdbc::NuoDB::VERSION
end

def rubyforge_project
  name
end

def date
  Date.today.to_s
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'" }
end

#############################################################################
#
# Standard tasks
#
#############################################################################

CLEAN.include('pkg')

Dir['tasks/**/*.rb'].each { |file| load file }

namespace :nuodb do

  task :install do
    if ENV['NUODB_ROOT'].nil?
      case RUBY_PLATFORM
        when /linux/i
          unless File.exists? '/etc/redhat-release'
            puts %x(wget http://www.nuodb.com/latest/nuodb-1.0-GA.linux.x86_64.deb --output-document=/var/tmp/nuodb.deb)
            puts %x(sudo dpkg -i /var/tmp/nuodb.deb)
          end
        else
          puts "Unsupported platform '#{RUBY_PLATFORM}'. Supported platforms are BSD, DARWIN, SOLARIS, and LINUX."
      end
    end
  end

  task :remove do
    if ENV['NUODB_ROOT'].nil?
      case RUBY_PLATFORM
        when /linux/i
          unless File.exists? '/etc/redhat-release'
            puts %x(sudo dpkg -r nuodb)
          end
        else
          puts "Unsupported platform '#{RUBY_PLATFORM}'. Supported platforms are BSD, DARWIN, SOLARIS, and LINUX."
      end
    end
  end

  task :create_user do
    #puts %x( echo "create user arunit password 'arunit';" | nuosql arunit@localhost --user dba --password dba )
  end

  task :start_server do
  end

  task :stop_server do
  end

  task :restart_server => [:stop_server, :start_server, :create_user]
end

task :spec => :build

task :default => :spec

#############################################################################
#
# Packaging tasks
#
#############################################################################

desc "Build #{gem_file} into the pkg directory"
task :build do
  sh 'mkdir -p pkg'
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

task :install => :build do
  sh %{jruby -S gem install pkg/#{name}-#{version}.gem}
end

task :uninstall do
  sh %{jruby -S gem uninstall #{name} -x -v #{version}}
end

desc 'Tags git with the latest gem version'
task :tag do
  sh %{git tag v#{version}}
end

desc 'Push gem packages'
task :push => :build do
  sh "gem push pkg/#{name}*.gem"
end

desc "Release version #{version}"
task :release => [:tag, :push]
