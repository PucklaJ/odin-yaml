set windows-shell := ['powershell.exe']

default: to

RUNIC := 'runic'
MAKE := if os() == 'linux' {
  'make'
} else if os() == 'macos' {
  'make'
} else {
  'gmake'
}

from: (make-directory 'build/runestones')
  {{ RUNIC }} --os linux --arch x86_64 from.yml > build/runestones/libyaml.linux.x86_64
  {{ RUNIC }} --os linux --arch arm64 from.yml > build/runestones/libyaml.linux.arm64
  {{ RUNIC }} --os windows --arch x86_64 from.yml > build/runestones/libyaml.windows.x86_64
  {{ RUNIC }} --os windows --arch arm64 from.yml > build/runestones/libyaml.windows.arm64
  {{ RUNIC }} --os macos --arch x86_64 from.yml > build/runestones/libyaml.macos.x86_64
  {{ RUNIC }} --os macos --arch arm64 from.yml > build/runestones/libyaml.macos.arm64

to: from
  {{ RUNIC }} to.yml

  echo '//+build amd64, arm64' > yaml.odin.tmp
  awk '{gsub(/\^char/, "cstring"); print}' yaml.odin >> yaml.odin.tmp
  mv yaml.odin.tmp yaml.odin

EXAMPLE_LINKER_FLAGS := if os() == 'linux' {
  '-extra-linker-flags=-Llib/linux'
} else {
  ''
}
YAML_STATIC := if os() == 'windows' {
  'true'
} else if os() == 'macos' {
  'true'
} else {
  'false'
}
example which='example' STATIC=YAML_STATIC: (make-directory 'build')
    odin build example/{{ which }}.odin -file -out:build/{{ which }}{{ if os() == 'windows' {'.exe'} else {''} }} -vet-style -vet-unused -vet-shadowing -error-pos-style:unix -debug {{ EXAMPLE_LINKER_FLAGS }} -define:YAML_STATIC={{ STATIC }}

[linux]
deps-debian:
  sudo apt install autoconf gcc make libtool

[macos]
deps:
  brew install autoconf libtool automake

SHARED_LIB := if os() == 'macos' {
  'dylib'
} else {
  'so'
}
[unix]
build: (make-directory 'lib/' + os())
  cd {{ justfile_directory() }}/shared/libyaml && ./bootstrap
  cd {{ justfile_directory() }}/shared/libyaml && ./configure
  {{ MAKE }} -C {{ justfile_directory() }}/shared/libyaml -j{{ num_cpus() }}

  ln -sf {{ justfile_directory() }}/shared/libyaml/src/.libs/libyaml.{{ SHARED_LIB }} {{ justfile_directory() }}/lib/{{ os() }}/libyaml.{{ SHARED_LIB }}
  ln -sf {{ justfile_directory() }}/shared/libyaml/src/.libs/libyaml.a {{ justfile_directory() }}/lib/{{ os() }}/libyaml.a

ARCH := if arch() == 'aarch64' { 'arm64' } else { arch() }
[windows]
build: (make-directory 'lib\windows\' + ARCH) (make-directory 'build\cmake')
  cmake -G "NMake Makefiles" -S shared\libyaml -B build\cmake -DBUILD_TESTING=NO -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded"
  cmake --build build\cmake
  Copy-Item -Path build\cmake\yaml.lib -Destination lib\windows\{{ ARCH }}\yaml.lib

  cmake -G "NMake Makefiles" -S shared\libyaml -B build\cmake -DBUILD_TESTING=NO -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded" -DBUILD_SHARED_LIBS=YES
  cmake --build build\cmake
  Copy-Item -Path build\cmake\yaml.lib -Destination lib\windows\{{ ARCH }}\yamld.lib
  Copy-Item -Path build\cmake\yaml.dll -Destination lib\windows\{{ ARCH }}\yaml.dll

[unix]
make-directory DIR:
  @mkdir -p "{{ DIR }}"

[windows]
make-directory DIR:
  @New-Item -Path "{{ DIR }}" -ItemType Directory -Force