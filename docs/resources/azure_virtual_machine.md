---
title: About the azure_virtual_machine Resource
---

# azure_virtual_machine

Use the `azure_virtual_machine` InSpec audit resource to ensure that a Virtual Machine has been provisionned correctly.

## References

- [Azure Ruby SDK - Compute](https://github.com/Azure/azure-sdk-for-ruby/tree/master/management/azure_mgmt_compute)

## Syntax

The name of the machine and the resourece group are required as attributes to the resource.

```ruby
describe azure_virtual_machine(name: 'MyVM', resource_group: 'MyResourceGroup') do
  its('matcher') { should eq 'value' }
end
```

where

* `MyVm` is the name of the virtual machine as seen in Azure. (It is **not** the hostname of the machine)
* `MyResourceGroup` is the name of the resouce group that the machine is in.
* `matcher` is one of
  - `publisher`
  - `offer`
  - `sku`
  - `size`
  - `location`
  - `boot_diagnostics?`
  - `nic_count`
  - `admin_username`
  - `computername`
  - `hostname`
  - `password_authentication?`
  - `ssh_key_count`
  - `os_type`
  - `private_ipaddresses`
  - `has_public_ipaddress?`
  - `domain_name_label`
* `value` is the expected output from the matcher

For example:

```ruby
describe azure_virtual_machine(name: 'chef-automate-01', resource_group: 'ChefAutomate') do
  its('os_type') { should eq 'Linux' }
  its('boot_diagnostics?') { should be false }
end
```

## Matchers

This InSpec audit resource has the following matchers:

### eq

Use the `eq` matcher to test the equality of two values: `its('Port') { should eq '22' }`.

Using `its('Port') { should eq 22 }` will fail because `22` is not a string value! Use the `cmp` matcher for less restrictive value comparisons.

### publisher

The publisher of the image from which this machine was built.

This will be `nil` if the machine was created from a custom image.

### offer

The offer from the publisher of the build image.

This will be `nil` if the machine was created from a custom image.

### sku

The item from the publisher that was used to create the image.

This will be `nil` if the machine was created from a custom image.

### size

The size of the machine in Azure

```ruby
its('size') { should eq 'Standard_DS2_v2' }
```

### location

Where the machine is located

```ruby
its('location') { should eq 'West Europe' }
```

### boot_diagnostics?

Boolean test to see if boot diagnostics have been enabled on the machine

```ruby
it { should have_boot_diagnostics }
```

### nic_count

The number of network interface cards that have been attached to the machine

### admin_username

The admin username that was assigned to the machine

NOTE:  Azure does not allow the use of `Administrator` as the admin username on a Windows machine

### computername

The computername of the machine. This is what was assigned to the machine during deployment and is what _should_ be returned by the `hostname` command.

### hostname

Alias for computername.

### password_authentication?

Boolean to state of password authentication is enabled or not for the admin user.

```ruby
its('password_authentication?') { should be false }
```

This only applies to Linux machines and will always return `true` on Windows.

### ssh_key_count

Returns how many SSH keys have been applied to the machine.

This only applies to Linux machines and will always return `0` on Windows.

### os_type

Generic test that returns either `Linux` or `Windows`.

### private_ipaddresses

Returns an array of all the private IP addresses that are assigned to the machine.  This is because a machine can multiple NICs and each NIC can have multiple IP Configurations.

```ruby
its('private_ipaddresses') { should include '10.1.1.10' }
```

### has_public_ipaddress?

Returns boolean to state if the machine has been allocated a Public IP Address.

```ruby
it { should have_public_ip_address }
```

### domain_name_label

If a machine has been allocated a Public IP Addresse test to see what domain name label has been set.

## Examples

The following examples show how to use this InSpec audit resource.

### Test that the machine was built from a Windows image

```ruby
describe azure_virtual_machine(name: 'chef-ws-01', resource_group: 'ChefAutomate') do
  its('publisher') { should eq 'MicrosoftWindowsServer' }
  its('offer') { should eq 'WindowsServer' }
  its('sku') { should eq '2012-R2-Datacenter' }
end
```

### Ensure the machine is in the correct location

```ruby
describe azure_virtual_machine(name: 'chef-ws-01', resource_group: 'ChefAutomate') do
  its('location') { should eq 'West Europe' }
end
