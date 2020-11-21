# Overview

This Ansible setup allows a user to configure a machine with a few things:

- Change the SSH port from 22 to 40022
- Install and configure the UFW firewall to block everything except 40022
- Install and configure fail2ban to ban attackers on port 40022
- Install some update scripts to update all of the Ubuntu packages
- Set a cron job to run this update daily
- Add a warning banner for SSH
- Create a new `operations` user with a temporary password. Also, force that user to change their password upon first logon. That user has `sudo` privilege too.

As of this writing, these Ansible roles could be used like this:

## STEP 1: Create an inventory file

Ansible can't do much on-the-fly. So, in the `/src` folder, create an `inventory.yaml` file with contents like this:

```text
all:
  hosts:
    x.x.x.x
  children:
    test:
      hosts:
        x.x.x.x
```

Where `x.x.x.x` is the IP address of your new virtual machine, that you want to configure. 

## STEP 2: Apply the "common" role to your machine

Then, run a command like this:

```bash
./ansible-run.sh x.x.x.x common
```

This will apply the `common` role to your server `x.x.x.x` which includes all of the things outlined above. In future releases, there will be other roles - but for now, this does some basic hardening of a server, which might be used for any purpose.