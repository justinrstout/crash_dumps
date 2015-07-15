directory node['crash_dumps']['directory'] do
  recursive true
  mode "0777"
end

if platform_family?('windows')

  #Possibly split out the download into it's own sysinternals cookbook
  directory node['crash_dumps']['procdump_installdir'] do
    recursive true
  end
  
  procdump_full_path = "#{node['crash_dumps']['procdump_installdir']}\\procdump.exe"

  remote_file procdump_full_path do
    source "#{node['crash_dumps']['url']}"
  end

  registry_key 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug' do
    values [{
        name: 'Auto',
        type: :string,
        data: '1'
      },
      {
        name: 'Debugger',
        type: :string,
        data: node['crash_dumps']['debugger']
      }]
  end
  
  registry_key 'HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\AeDebug' do
    values [{
        name: 'Auto',
        type: :string,
        data: '1'
      },
      {
        name: 'Debugger',
        type: :string,
        data: node['crash_dumps']['debugger']
      }]
  end

  registry_key 'HKLM\Software\Microsoft\Windows\Windows Error Reporting' do
    values [{
      name: 'DontShowUI',
      type: :dword,
      data: 1
    }]
  end

 # execute 'net use \\\\live.sysinternals.com'
else
  file_append "/etc/security/limits.conf" do
    line "#{node['crash_dumps']['user']} - core -1"
  end
  
  execute "sysctl -w kernel.core_pattern=\"#{node['crash_dumps']['directory']}/#{node['crash_dumps']['pattern']}\""

  file_append "/etc/sysctl.conf" do
    line "kernel.core_pattern=#{node['crash_dumps']['directory']}/#{node['crash_dumps']['pattern']}"
  end
  
  service "abrt-ccpp" do
    action :disable
  end
end