# phealot

Peter's Hesiod Automount Lookup Tool

An executable perl script for lookup of Automounter data in DNS.
Works on Linux, FreeBSD, Solaris, MacOS (and possibly others).

Enumeration (using DNS zone transfer) only works with the FreeBSD 
and MacOS automounters as far as I know.


## DNS TXT record formats supported:

### Hesiod style:
    NFS /staff/user1 server.my.zone.com - /home/user1
    NFS /staff/user1 server.my.zone.com ro /home/user1

### AMD style:
    type:=nfs;rhost:=server.my.zone.com;rfs:=/staff/user1
    type:=nfs;opts:=ro;rhost:=server.my.zone.com;rfs:=/staff/user1

### Sun style:
    server.my.zone.com:/staff/user1
    -ro server.my.zone.com:/staff/user1


## Usage:

1. Edit $zone_base in the script for your Hesiod/DNS automounter base zone.
2. Put the script somewhere (/sbin, /usr/libexec?).
3. Create a directory (if it doesn't exist) /etc/autofs.
4. Create symlinks in that directory named after the map you want to look up:
5. Create entries in /etc/auto.master.d like:


### Example:

    mkdir -p /etc/autofs
    cd /etc/autofs
    ln -s /usr/libexec/autofs-dns-lookup home
    ln -s /usr/libexec/autofs-dns-lookup pkg
    
    cd /etc/auto.master.d
    echo '/home program:/etc/autofs/home vers=4,sec=krb5'   >home.autofs
    echo '/pkg  program:/etc/autofs/pkg  vers=4,sec=sys,ro' >pkg.autofs

6. Populate a DNS zone with records in one of the three formats above.
Please note that "filsys.hesiod.$ZONE" is handled as a special case for "home" 
(so there is no "home.automount.hesiod.$ZONE").


### DNS record examples:

    $ORIGIN filsys.hesiod.my.zone.com.
    user1   IN    TXT    "NFS /staff/user1 server.my.zone.com - /home/user1"
    
    $ORIGIN pkg.automount.hesiod.my.zone.com.
    matlab  IN   TXT     "type:=nfs;rhost:=server.my.zone.com;rfs:=/linux/matlab"
    labview IN   TXT     "-ro server.my.zone.com:/linux/labview"
    

## More information

For more information about the HESIOD system, see:

  https://en.wikipedia.org/wiki/Hesiod_(name_service)
