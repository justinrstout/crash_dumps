if platform_family?('windows')
  registry_key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug' do
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
  
  registry_key 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\AeDebug' do
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
else
  file_append "/etc/security/limits.conf" do
    line "root - core -1"
  end
  
  execute "sysctl -w kernel.core_pattern=\"#{node['crash_dumps']['directory']}/core.%e%N%d%f.%t.%p\""

  file_append "/etc/sysctl.conf" do
    line "kernel.core_pattern=#{node['crash_dumps']['directory']}/core.%e%N%d%f.%t.%p"
  end
  
  service "abrt-ccpp" do
    action :disable
  end
end