#!/usr/bin/env ruby
require 'dnssd'
require 'timeout'
require 'pp'
require 'tty-table'

replies = []
begin
  Timeout::timeout(10) do
    DNSSD.browse!('_http._tcp', nil, 0, 'en6') do |reply|
      DNSSD.resolve(reply) do |resolve|
        puts pp resolve.text_record
        path = resolve.text_record["path"]
        platform = resolve.text_record["platform"]
        replies << [resolve.name, resolve.port, resolve.target,
                    IPSocket.getaddress(resolve.target),
                    path, platform]
      end
    end
  end
rescue Timeout::Error
end

table = TTY::Table.new(%w/name port target ip path platform/,
                       replies.uniq { |s| s[2] }.sort_by { |s| s[0] })
puts table.render(:unicode, padding: [0,1])

