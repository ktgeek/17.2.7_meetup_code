#!/usr/bin/env ruby
require 'dnssd'
require 'timeout'
require 'tty-table'

services = []
begin
  Timeout::timeout(10) do
    DNSSD.browse!('_services._dns-sd._udp', nil,0, 'en6') do |reply|
      services << [reply.domain, reply.type, reply.name]
    end
  end
rescue Timeout::Error
end

table = TTY::Table.new(%w/domain type name/,
                       services.sort_by { |s| s[2] })
puts table.render(:unicode, padding: [0,2])
