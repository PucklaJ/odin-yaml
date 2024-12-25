set windows-shell := ['powershell.exe']

default: bindings

RUNIC := 'runic'
MAKE := if os() == 'linux' { 'make' } else { if os() == 'macos' { 'make' } else { 'gmake' } }

bindings:
    {{ RUNIC }}

    sed yaml.odin -i \
        -e 's/\^char/cstring/g'

example which='example' STATIC='true': (make-directory 'build')
    odin build example/{{ which }}.odin -file -out:build/{{ which }}{{ if os() == 'windows' { '.exe' } else { '' } }} -vet-style -vet-unused -vet-shadowing -error-pos-style:unix -debug -define:YAML_STATIC={{ STATIC }}

[linux]
deps-debian:
    sudo apt install autoconf gcc make libtool

[linux]
deps-alpine:
    sudo apk add build-base autoconf automake libtool

[macos]
deps:
    brew install autoconf libtool automake

# [freebsd]
# deps:
#   pkg install -y autoconf libtool automake

[unix]
build: (make-directory 'lib/' / os() / arch())
    cd {{ justfile_directory() }}/shared/libyaml && ./bootstrap
    cd {{ justfile_directory() }}/shared/libyaml && ./configure
    {{ MAKE }} -C {{ justfile_directory() }}/shared/libyaml -j{{ num_cpus() }}

    cp {{ justfile_directory() }}/shared/libyaml/src/.libs/libyaml.a {{ justfile_directory() }}/lib/{{ os() }}/{{ arch() }}/

[windows]
build: (make-directory 'lib\windows\' + ARCH) (make-directory 'build\cmake')
    cmake -G "NMake Makefiles" -S shared\libyaml -B build\cmake -DBUILD_TESTING=NO -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded"
    cmake --build build\cmake
    Copy-Item -Path build\cmake\yaml.lib -Destination lib\windows\{{ arch() }}\yaml.lib

    cmake -G "NMake Makefiles" -S shared\libyaml -B build\cmake -DBUILD_TESTING=NO -DCMAKE_POLICY_DEFAULT_CMP0091=NEW -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded" -DBUILD_SHARED_LIBS=YES
    cmake --build build\cmake
    Copy-Item -Path build\cmake\yaml.lib -Destination lib\windows\{{ arch() }}\yamld.lib
    Copy-Item -Path build\cmake\yaml.dll -Destination lib\windows\{{ arch() }}\yaml.dll

check:
    odin check . -vet -error-pos-style:unix -no-entry-point

[unix]
make-directory DIR:
    @mkdir -p "{{ DIR }}"

[windows]
make-directory DIR:
    @New-Item -Path "{{ DIR }}" -ItemType Directory -Force
