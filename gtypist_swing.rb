#!/usr/bin/env jruby
# -*- mode: ruby; coding: utf-8 -*-
# programmed by Hiroshi Kimura, 2012-04-22.
#
# 本日の gtypist のスコアを表示する学生向けスクリプト。
#
# TODO: 2012-04-25, クリアしたステージを刻々と表示するように。
#  => done 2012-05-03.
#
# isc で実行すると非常に遅い、か? 再チェック。
#
DEBUG=true
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
    @displayed=Hash.new
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

  def update(records)
    records.each do |r|
      debug "record:#{r}"
      if @displayed.member?(r)
        next
      else
        @text_area.append(r+"\n")
        @displayed[r]=true
      end
    end
  end
end

def cleared_stages(fname)
  ret=Array.new
  last_stage=""
  File.foreach(fname) do |line|
    line=line.chomp
    wday,month,date,time,year,rest=line.split(/\s+/,6)
    if rest=~/with (\d+)\.(\d+)%/
      if "#{$1}.#{$2}".to_f <= 3.0
        ret.push last_stage
      end
    else
      last_stage=line
    end
  end
  ret
end

# main starts here.

begin
  app=MyApp.new
  fname = File.join(ENV['HOME'],'.gtypist')
  while not File.exists?(fname)
    sleep(INTERVAL)
  end
  while true
    stages = cleared_stages(fname)
    app.update(stages)
    sleep(INTERVAL)
  end

rescue =>e
  puts e.message
end
