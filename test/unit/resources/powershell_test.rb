# encoding: utf-8

require 'helper'
require 'inspec/resource'

describe 'Inspec::Resources::Powershell' do

  ps1_script = <<-EOH
    # call help for get command
    Get-Help Get-Command
  EOH

  it 'check if `powershell` for windows is properly generated ' do
    resource = MockLoader.new(:windows).load_resource('powershell', ps1_script)
    # string should be the same
    _(resource.command.to_s).must_equal ps1_script
  end

  it 'check if legacy `script` for windows is properly generated ' do
    proc {
      resource = MockLoader.new(:windows).load_resource('script', ps1_script)
      resource.command.to_s.must_equal ps1_script
    }.must_output nil, "[DEPRECATION] `script(script)` is deprecated.  Please use `powershell(script)` instead.\n"
    # string should be the same
  end

  it 'will return an empty array when called on a non-supported OS with children' do
    resource = MockLoader.new.load_resource('powershell', '...')
    # string should be the same
    _(resource.stdout).must_equal ''
  end
end
