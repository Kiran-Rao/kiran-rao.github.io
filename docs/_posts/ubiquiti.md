# What I need to setup Unifi

- Reliability
- Speed
- Lots of Clients
- Big House

## It's hard to select

- Setting up a ubiquiti network seems intimidating
- A lot of pieces
- Don't know what to buy

## You need 4 picees

1. Router/Firewall
2. Switch
3. Wireless Access Point
4. Network Controller

## We will go into:

- What they do/why we need them
- Examples
- Link to more resources

# Router/Firewall

## What they do:

- Translator between outside network (internet) and inside network
- Create Site-Site VPN/Client-Site VPN
- Protect against certain types of attacks/decide what to allow in

## Examples

- https://www.ui.com/unifi-routing/usg/
- https://www.ui.com/unifi-routing/unifi-security-gateway-pro-4/

# Switch

## What they do:

- Allow all devices to communicate with eachother
- DHCP
- VLAN
- PoE

## Examples

- https://www.ui.com/unifi-switching/unifi-switch-8/
- https://www.ui.com/unifi-switching/unifi-switch-2448/

# Access Point

## What it is

- Connects to wireless devices
- Can have more than one throughout the house
- Best if wired, but can work in mesh
- Mostly PoE, some include injectors, some don't

## Examples

- https://unifi-nanohd.ui.com/
- https://unifi-flexhd.ui.com/
- https://inwall-hd.ui.com/

# Network Controller

## What is it

- Software Defined Networking
- Camera Software/Recording
- Can run it on your own computer (even a RPI/docker)
- Probably shouldn't, use theirs

## Examples

- https://www.ui.com/download/unifi/default/default/unifi-network-controller-51332-debianubuntu-linux-and-unifi-cloud-key
- https://unifi-protect.ui.com/cloud-key-gen2

# Dream Machine

- Dream Machine Pro combines Router, Switch, Network Controller,
- Dream Machine has all 4 (but slower speed)
- Good starting point for most deployments
  https://unifi-network.ui.com/dreammachine

# Conclusion

- Networking is confusing
- Hope this makes it easier
