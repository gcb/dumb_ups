dumb UPS
========

Making dumb UPS smart.

Connect your home server to a non battery-backed switch.

When power goes down, it will sense the carrier loss on
on the network interface connected to said switch and
schedule a shutdown.

```
# pacman -S dumb_ups
# systemctl edit dumb_ups.service

edit the environment lines, e.g.
Environment="DUMB_UPS_IF_NAME=ethf0"

# systemctl enable --now dumb_ups.timer
```

Inspiration: https://superuser.com/a/1867082/43268
