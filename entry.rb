#! /usr/bin/env ruby

require './resolver'

if ARGV.empty?
  puts 'Please specify argument(s).'
  return
end

if ARGV.length == 1
  Resolver.crawl_cigarette_attributes(ARGV[0])
  return
end

if ARGV[0].to_i > ARGV[1].to_i
  puts "start id must be less than end id!"
  return
else
  (ARGV[0]..ARGV[1]).each { |cigarette_id| Resolver.crawl_cigarette_attributes(cigarette_id) }
end


