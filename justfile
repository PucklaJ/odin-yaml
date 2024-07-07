default: to

RUNIC := 'runic'

from:
  @mkdir -p build/runestones
  {{ RUNIC }} --os linux --arch x86_64 from.json > build/runestones/libyaml.linux.x86_64
  {{ RUNIC }} --os windows --arch x86_64 from.json > build/runestones/libyaml.windows.x86_64
  {{ RUNIC }} --os macos --arch x86_64 from.json > build/runestones/libyaml.macos.x86_64

to: from
  {{ RUNIC }} to.json

  echo '//+build amd64, arm64' > yaml.odin.tmp
  awk '{gsub(/\^char_t/, "cstring"); print}' yaml.odin >> yaml.odin.tmp
  mv yaml.odin.tmp yaml.odin

example:
    @mkdir -p build
    odin build example -out:build/example{{ if os() == 'windows' {'.exe'} else {''} }} -vet
