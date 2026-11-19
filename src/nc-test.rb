# usage: ruby nc-test.rb ClassName [big]   -- tests one step with a nasty payload; exits 0 on OK
require_relative "code-gen"
ENV["PATH"] = "vendor/local/bin:#{ ENV["PATH"] }"
dir = File.join(File.dirname(__dir__), "tmp-nc-#{ARGV[0]}")
Dir.mkdir(dir) unless File.directory?(dir)
Dir.chdir(dir)
File.symlink("../vendor", "vendor") unless File.symlink?("vendor")
pr = (32..126).map(&:chr).join
text = "Hello\n" + pr + "\n" + pr.reverse + "\n\"''\\\\n\\\\\\\"%s%d~@-*$;()#\t|\n" + ("x"*700) + "\n" + (pr*12) + "\n"
text = text * 400 if ARGV[1].to_s.include?("big")
text = text.tr("\n", " ") if ARGV[1].to_s.include?("nonl")
text = text.gsub(/[^\n]{150}/){$&+"\n"} if ARGV[1].to_s.include?("short")
text = text * ENV["NC_REP"].to_i if ENV["NC_REP"]
cls = eval(ARGV[0]); gst = cls.gen_step
begin; gst.check.call(text); rescue => e; puts "check() rejects test text (#{e.class}); trying anyway"; end
code = Object.new.instance_eval(GenPrologue + gst.code.sub("PREV") { text.dump }) + "\n"
steps = [*gst.run_steps, RunStep[nil, "QR.txt"]]
File.write(steps.first.src, code)
steps.each_cons(2) { |s, d| c = s.cmd_raw.gsub("OUTFILE", d.src); puts "cmd: "+c[0,200]; system(c) || (puts "result: FAILED"; exit 1) }
out = File.binread("QR.txt")
ok = out == text
puts "result: #{ok ? 'OK (exact)' : (out.strip == text.strip ? 'OK (strip only)' : 'NG')}  bytes out=#{out.bytesize} want=#{text.bytesize} src=#{File.size(steps.first.src)}"
unless ok
  i = (0...[out.size,text.size].min).find { |k| out[k] != text[k] } || [out.size,text.size].min
  puts "first diff at #{i}: got #{out[i-20,50].inspect}\n want #{text[i-20,50].inspect}"
end
exit(ok ? 0 : 1)
