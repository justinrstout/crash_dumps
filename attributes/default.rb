default['crash_dumps']['directory'] = "C:\\dumps"
default['crash_dumps']['pattern'] = "core.%e%N%d%f.%t.%p"
default['crash_dumps']['debugger'] = "\"\\\\live.sysinternals.com\\Tools\\procdump.exe\" -accepteula -mp -j \"#{node['crash_dumps']['directory']}\" %ld %ld %p"