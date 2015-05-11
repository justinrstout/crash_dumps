default['crash_dumps']['user'] = "root"
default['crash_dumps']['directory'] = "C:\\dumps"
default['crash_dumps']['pattern'] = "core.%e%N%d%f.%t.%p"
default['crash_dumps']['procdump_installdir'] = "C:\\Program Files\\sysinternals"
default['crash_dumps']['debugger'] = "\"#{node['crash_dumps']['procdump_installdir']}\\procdump.exe\" -accepteula -mp -j \"#{node['crash_dumps']['directory']}\" %ld %ld %p"
default['crash_dumps']['url'] = "http://live.sysinternals.com/procdump.exe"