# encoding: UTF-8

require 'colorize'
require 'tty'

options = Central::Devtools.project.container.options
version = options['build_tag'].to_s
versions = if version.nil? || version == 'latest'
             ['latest']
           else
             ['latest', version.match(/(\d+\.\d+)/)[1]].freeze
           end
name = "#{options['prefix']}/#{options['component']}"
from = "#{options['from_image']}:#{options['from_version']}"

def msg(text)
  ttable = TTY::Table.new
  ttable << [text]
  renderer = TTY::Table::Renderer::Unicode.new(ttable)
  renderer.border.style = :red
  puts renderer.render
end

def pull
  ' ↓ '.colorize(:red)
end

def push
  ' ↑ '.colorize(:light_red)
end

def tag
  ' ✓ '.colorize(:green)
end

def spin
  ' ↻ '.colorize(:cyan)
end

def sync
  ' ⎘ '.colorize(:light_green)
end

def build
  ' ◴ '.colorize(:light_magenta)
end

namespace :docker do
  desc "Build #{name} container from #{from}"
  task build: ['docker:build:task']

  namespace :build do
    task :task do
      msg "#{pull} docker pull #{from.colorize(:cyan)} "
      sh "docker pull #{from}"
      msg "#{build} docker build --no-cache --force-rm -t #{name.colorize(:cyan)}:#{version.colorize(:cyan)} "
      sh "docker build --no-cache --force-rm -t #{name}:#{version} ."

      versions.each do |v|
        msg "#{tag} docker tag #{name.colorize(:yellow)}:#{version.colorize(:cyan)} #{name.colorize(:yellow)}:#{v.colorize(:cyan)} "
        sh "docker tag #{name}:#{version} #{name}:#{v}"
      end
    end
  end

  desc "Push image #{name}"
  task push: ['docker:push:task']

  namespace :push do
    task task: ['docker:build'] do
      msg "#{push} docker push #{name.colorize(:cyan)}:#{version.colorize(:cyan)} "
      sh "docker push #{name}:#{version}"

      versions.each do |v|
        msg "#{push} docker push #{name.colorize(:yellow)}:#{v.colorize(:cyan)} "
        sh "docker push #{name}:#{v}"
      end
    end
  end
end
