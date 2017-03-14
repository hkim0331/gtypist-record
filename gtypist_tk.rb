#!/edu/bin/ruby
# -*- mode: ruby; coding: utf-8 -*-
# programmed by Hiroshi Kimura, 2012-04-22.
#
# 本日の gtypist のスコアを表示する学生向けスクリプト。
# jruby で遅すぎるので、tk で書き直し。
#
# TODO: 2012-04-25, クリアしたステージを刻々と表示するように。
# => done 2012-05-03.
#
# VERSION: 0.6.6
#
DEBUG=false
INTERVAL=3
require 'tk'

M={"Jan"=>"01", "Feb"=>"02", "Mar"=>"03", "Apr"=>"04",
   "May"=>"05", "Jun"=>"06", "Jul"=>"07", "Aug"=>"08",
   "Sep"=>"09", "Oct"=>"10","Nov"=>"11","Dec"=>"12"}

def debug(s)
  puts "debug: "+s if DEBUG
end

def osx?
  RUBY_PLATFORM=~/darwin/
end

def D(d)
  if d.to_i<10
    "0"+d
  else
    d
  end
end

class MyApp
  def initialize
    root=TkRoot.new
    root.title='gtypist'
    frame=TkFrame.new(root)
    @text=TkText.new(frame)
    @text.configure(width: 30,height: 10,background: 'white')
    @text.tag_configure('new',:background=>'red',:foreground=>'white')
    @text.pack(side: 'right')
    scr=TkScrollbar.new(frame)
    scr.pack(side: 'left',fill: 'y')
    @text.yscrollbar(scr)
    @text.configure(state:'disabled')
    frame.pack
  end

  def update(data)
    @text.configure(state:'normal')
    @text.delete('1.0','end')
    @text.insert('end',data.reverse.join("\n"))
    @text.tag_add('new',"#{data.length}.0",'end')
    @text.see('end')
    @text.configure(state:'disabled')
  end
end
#
# main starts here.
#
begin
  fname=File.join(ENV['HOME'],".gtypist")
  debug "fname:#{fname}"
  # 起動直後にはまだファイルがないときもある。
  #  raise "記録が見つかりません。#{fname}" unless File.exists?(fname)

  now=Time.now
  results=Array.new
  app=MyApp.new
  app.update(["programmed", "by", "hiroshi kimura."].reverse)
  lines=Array.new
  old_lines=Array.new

  Thread.new do
    while true
      flag=cleared=rate=nil
      results.clear
      sleep(INTERVAL)
      next unless File.exists?(fname)
      lines=IO.readlines(fname)
      next if lines==old_lines
      lines.reverse.each do |line|
        wday,month,date,time,year,rest=line.chomp.split(/\s+/,6)
        unless now.day.to_i == date.to_i
          debug "not today: #{line}"
          next
        end
        if flag
          next unless rest=~/\*:(.*)$/
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
      old_lines=lines
    end
  end
  Tk.mainloop

rescue =>e
  puts e.message
end
