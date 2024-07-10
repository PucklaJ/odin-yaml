set windows-shell := ['powershell.exe']

default: to

RUNIC := 'runic'
MAKE := if os() == 'linux' {
  'make'
} else {
  'gmake'
}

from:
  @mkdir -p build/runestones
  {{ RUNIC }} --os linux --arch x86_64 from.json > build/runestones/libyaml.linux.x86_64
  {{ RUNIC }} --os windows --arch x86_64 from.json > build/runestones/libyaml.windows.x86_64
  {{ RUNIC }} --os macos --arch x86_64 from.json > build/runestones/libyaml.macos.x86_64

to: from
  {{ RUNIC }} to.json

  echo '//+build amd64, arm64' > yaml.odin.tmp
  awk '{gsub(/\^char/, "cstring"); print}' yaml.odin >> yaml.odin.tmp
  mv yaml.odin.tmp yaml.odin

EXAMPLE_LINKER_FLAGS := if os() == 'linux' {
  '-extra-linker-flags=-Llib/linux'
} else {
  ''
}
example which='example':
    @mkdir -p build
    odin build example/{{ which }}.odin -file -out:build/{{ which }}{{ if os() == 'windows' {'.exe'} else {''} }} -vet-style -vet-unused -vet-shadowing -error-pos-style:unix -debug {{ EXAMPLE_LINKER_FLAGS }}

[linux]
deps-debian:
  sudo apt install autoconf gcc make libtool

[unix]
build:
  @mkdir -p lib/{{ os() }}
  cd shared/libyaml && ./bootstrap
  cd shared/libyaml && ./configure
  {{ MAKE }} -C shared/libyaml -j{{ num_cpus() }}

  ln -rsf shared/libyaml/src/.libs/libyaml.so lib/{{ os() }}/libyaml.so
  ln -rsf shared/libyaml/src/.libs/libyaml.a lib/{{ os() }}/libyaml.a

ARCH := if arch() == 'aarch64' { 'arm64' } else { arch() }
[windows]
build:
  @New-Item -Path lib\windows\{{ ARCH }} -ItemType Directory -Force
  @New-Item -Path build\cmake -ItemType Directory -Force

  cmake -G "NMake Makefiles" -S shared\libyaml -B build\cmake -DBUILD_TESTING=NO
  cmake --build build\cmake

  Copy-Item -Path build\cmake\yaml.lib -Destination lib\windows\{{ ARCH }}\yaml.lib