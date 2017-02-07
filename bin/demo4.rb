#!/usr/bin/env ruby
require 'dnssd'
require 'timeout'
require 'tty'
require 'tty-spinner'
require 'tty-table'
require 'tty-pager'

spinner = TTY::Spinner.new("Looking up services: :spinner ...",
                           format: :bouncing_ball)

services = []
spinner.run("Lookups Done!") do
  begin
    Timeout::timeout(10) do
      DNSSD.browse!('_services._dns-sd._udp', nil,0, 'en6') do |reply|
        services << [reply.domain, reply.type, reply.name]
      end
    end
  rescue Timeout::Error
  end
end

table = TTY::Table.new(%w/domain type name/,
                       services.sort_by { |s| s[2] })
pager = TTY::Pager::BasicPager.new
pager.page(table.render(:unicode, padding: [0,2]))
