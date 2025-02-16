# Starting this Presentation

There are two scripts `start-presentation-unix.sh` and
`start-presentation-win.cmd` which help in starting these presentations under
`*nix` and `windows` systems.

## Manual

You need to start this presentation with disabling web-security since it loads
JavaScript plugins and files from the disk:

```shell
google-chrome \
  --new-window \
  --disable-web-security \
  -–allow-file-access-from-files \
  "index.html"
```
