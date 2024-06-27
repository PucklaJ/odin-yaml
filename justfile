default: to

RUNIC := 'shared/runic/build/runic'

from:
  @mkdir -p build/runestones
  {{ RUNIC }} --os linux --arch x86_64 from.json > build/runestones/libyaml.linux.x86_64
  {{ RUNIC }} --os windows --arch x86_64 from.json > build/runestones/libyaml.windows.x86_64
  {{ RUNIC }} --os macos --arch x86_64 from.json > build/runestones/libyaml.macos.x86_64

to: from
  {{ RUNIC }} to.json

runic:
  just -f shared/runic/justfile

example:
    @mkdir -p build
    odin build example -out:build/example{{ if os() == 'windows' {'.exe'} else {''} }} -vet
