---
title:  About the azure_virtual_machine_datadisks Resource
---

# azure_virtual_machine_datadisks

Use this resource to check that the correct number of data disks have been applied to the machine and that they are of the correct size.

## References

- [Azure Ruby SDK - Compute](https://github.com/Azure/azure-sdk-for-ruby/tree/master/management/azure_mgmt_compute)

## Syntax

The name of the resource group and machine are required to use this resource.

```ruby
describe azure_virtual_machine(name: 'MyVM', resource_group: 'MyResourceGroup') do
  its('matcher') { should eq 'value' }
end
```

where 

* `MyVm` is the name of the virtual machine as seen in Azure. (It is **not** the hostname of the machine)
* `MyResourceGroup` is the name of the resouce group that the machine is in.
* `matcher` is one of
   - `count` the number of data disks attached to the machine
   - `has_disks?` boolean test denoting if data disks are attached
   - `entries` used with the `where` filter to check the size of a disk
* `value` is the expected output fdrom the matcher

## Matchers

This InSpec audit resource has the following matchers:

### eq

Use the `eq` matcher to test the equality of two values: `its('Port') { should eq '22' }`.

Using `its('Port') { should eq 22 }` will fail because `22` is not a string value! Use the `cmp` matcher for less restrictive value comparisons.

### count

Returns the number of data disks attached to the machine

```ruby
its('count') { should eq 1 }
```

### has_disks?

Returns a boolean denoting if any data disks are attached to the machine

```ruby
its('has_disks?') { should be true }
```

### entries

The `entries` filter can be used to check the attributes of indivdual data disks:

```ruby
its('entries') { should_not be_empty }
```

This matcher is best used in conjunction with filters. For example the following tests that the first data disk has a capacity greater than 10gb.

```ruby
describe azure_virtual_machine_datadisks(name: 'MyVM', resource_group: 'MyResourceGroup').where { disk.zero? and size > 10 } do
  its('entries') { should_not be_empty }
end
```

## Examples

None