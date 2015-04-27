if platform_family?('windows')
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
        type: :dword,
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
else
  directory node['crash_dumps']['directory'] do
    recursive true
  end

  file_append "/etc/security/limits.conf" do
    line "root - core -1"
  end
  
  execute "sysctl -w kernel.core_pattern=\"#{node['crash_dumps']['directory']}/#{node['crash_dumps']['pattern']}\""

  file_append "/etc/sysctl.conf" do
    line "kernel.core_pattern=#{node['crash_dumps']['directory']}/#{node['crash_dumps']['pattern']}"
  end
  
  service "abrt-ccpp" do
    action :disable
  end
end