#!/usr/bin/env ruby

require 'prawn'
require 'byebug'

mp3s = File.read(ARGV[0]).split("\n")
mp3s = mp3s.map do |filename|
  parts = filename.split('/')
  track = parts[-1]
  next if track == ".DS_Store"
  next if track.start_with?('._')
  next unless track.end_with?('.m4a') || track.end_with?('.mp3')
  album = parts[-2]
  [filename, album, track]
end.compact.group_by { |m| m[1] }.sort_by { |k, v| k }


# mp3s: { "album name" => [filename, album name, track name] }
Prawn::Document.generate("mp3_list.pdf") do
  font_families.update(
    "Arial" => {
      normal: "/Library/Fonts/Arial.ttf",
      italic: "/Library/Fonts/Arial Italic.ttf",
      bold: "/Library/Fonts/Arial Bold.ttf",
      bold_italic: "/Library/Fonts/Arial Bold Italic.ttf"
    })

  font "Arial"

  text "Ruby Meetup Sample File", align: :center, size: 18
  text "Behold my music collection", align: :center, size: 14

  move_down 10

  column_box([0, cursor], columns: 2, width: bounds.width) do
    mp3s.each do |album, tracks|
      text album, size: 12, style: :bold

      tracks.sort_by { |track| track[2] }.each do |track|
        color = track[2].end_with?('.mp3') ? "FF0000" : "0000FF"
        text track[2], size: 8, indent_paragraphs: 5, color: color
      end

      move_down 10
    end
  end
end
