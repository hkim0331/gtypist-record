#!/usr/bin/env jruby
# -*- mode: ruby; coding: utf-8 -*-
# programmed by Hiroshi Kimura, 2012-04-22.
#
# 本日の gtypist のスコアを表示する学生向けスクリプト。
#
# TODO: 2012-04-25, クリアしたステージを刻々と表示するように。
# 	=> done 2012-05-03.
#
# this is a part of icome4/utils
# VERSION: 0.6.6
#
# isc で実行すると非常に遅い。
# tk で書き直し。
#
# JRuby can not.
#DEBUG=(RUBY_PLATFORM=~/darwin/)
DEBUG=File.directory?("/Applications")
INTERVAL=5

include Java
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JScrollPane
import javax.swing.JTextArea

def debug(s)
  puts "debug: "+s if DEBUG
end

M={"Jan"=>"01", "Feb"=>"02", "Mar"=>"03", "Apr"=>"04",
   "May"=>"05", "Jun"=>"06", "Jul"=>"07", "Aug"=>"08",
   "Sep"=>"09", "Oct"=>"10","Nov"=>"11","Dec"=>"12"}

def D(d)
  if d.to_i<10
    "0"+d
  else
    d
  end
end

class MyApp
  def initialize
    frame=JFrame.new("gtypist")
    frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    panel=JPanel.new

    @text_area=JTextArea.new(20,20)
    @text_area.set_editable(false)
    sc=JScrollPane.new
    sc.setViewportView(@text_area)
    panel.add(sc)
    frame.add(panel)
    frame.pack
    frame.set_visible(true)
  end

  def update(data)
    @text_area.set_text(data.reverse.join("\n"))
  end
end
#
# main starts here.
#
begin
  fname=File.join(ENV['HOME'],'.gtypist')
# 起動直後にはまだファイルがないときもある。
#  raise "記録が見つかりません。#{fname}" unless File.exists?(fname)

  now=Time.now
  app=MyApp.new
  results=Array.new

  while true
    flag=cleared=rate=nil
    sleep(INTERVAL)
    next unless File.exists?(fname)
    IO.readlines(fname).reverse.each do |line|
      #    debug line
      wday,month,date,time,year,rest=line.chomp.split(/\s+/,6)
      unless now.day.to_i == date.to_i
        debug "not today: #{line}"
        next
      end
      if flag
        #      debug "found, rest:#{rest}"
        next unless rest=~/\*:(.*)$/
        #      debug "found2"
        score=$1
        results.push "#{cleared} #{score}" if score=~/_.+_.+_/
        flag=cleared=rate=nil
      else
        if rest=~/with (\d)\.(\d)% errors/
          rate="#{$1}.#{$2}".to_f
          if rate < 3.0
            cleared="#{year}-#{M[month]}-#{D(date)} #{time}"
            flag=true
          end
        end
      end
    end
    app.update(results)
  end

rescue =>e
  puts e.message
end
