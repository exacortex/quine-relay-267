# Quine Relay 267 *(Superseded Stepping Stone)*

> [!NOTE]
> **Superseded by [exacortex/quine-relay-256](https://github.com/exacortex/quine-relay-256).**
> This 267-step build was an intermediate milestone. The final, strictly audited release is **[exacortex/quine-relay-256](https://github.com/exacortex/quine-relay-256)** — exact **256 steps = 256 distinct languages** (dropping Tier 2 completely, restoring all 123 single-implementation `mame-128` languages including verbatim zero-`fopen` `Scilab -> sed -> Shakespeare -> S-Lang`, adding **Malbolge Unshackled**, replacing all custom mock interpreters with canonical upstream tools, and eliminating every remaining corner cut).

**A 267-step quine relay across 257 distinct programming languages, built under Yusuke Endoh's no-cheating rules and verified from a clean Ubuntu 26.04 Docker build.**
It extends [Yusuke Endoh's Quine Relay](https://github.com/mame/quine-relay) (128 steps / 123 distinct languages) with 143 more steps (138 new distinct languages).

This is a milestone. The final form we're working toward is 256 steps.

## What this is

[QR.rb](QR.rb) is a Ruby program that generates
a Simula program that generates
a Oberon program that generates
...(through 267 steps / 257 distinct languages in total)...
a REXX program that generates
the original Ruby code again.

![Language Uroboros][langs]

[langs]: langs.png

The languages in red are the 143 steps added in this fork. Everything in black is from mame's Ubuntu 26.04 relay.

## The rules every step follows

mame looked at our earlier 284-step fork and named three things he treats as cheating. Every step here follows all three:

1. **No code on the command line.** A command names the program file and sets options. It never carries program text (`node -e '...'`, a `printf` that adds code, and so on).
2. **No reading files.** No program opens its own source or another step's file. The text it prints lives inside the program.
3. **Output on stdout only.** No writing a file and then `cat`, and no cleaning a tool's output with `tail`, `grep` or `tr`.

Getting there took two audits. 13 languages couldn't put clean text on stdout and were removed. Four of mame's own languages (Scilab, sed, Shakespeare, S-Lang) were dropped too, because S-Lang could only get its text by reading sed's file. [NO-CHEAT.md](NO-CHEAT.md) and [AUDIT-2.md](AUDIT-2.md) list every change and the few judgment calls we kept where mame's own relay does the same thing.

## Proof that it works

On November 19, 2026, this repository's [`Dockerfile`](Dockerfile) was built from scratch (`docker build --pull --no-cache`, `FROM ubuntu:26.04`, 79.9 minutes), and the image ran its own `make check -j 10000` (23.9 minutes):

- **All 267 steps ran in order on their real interpreters and compilers.** No stand-ins, no skipped steps.
- **Every intermediate file matched [`SHA256SUMS`](SHA256SUMS)** (all 267 of them, the same way mame's relay checks).
- **Step 267 (REXX) printed `QR2.rb`, byte-for-byte identical to `QR.rb`** (34888 bytes, SHA-256 `e96516bb0a3eb73e6f6163d8c93bf7725394c6b419dfe2d072f3e9f1d531c701`).

The build log, run log and result are in [`proof/`](proof/). Anyone can repeat it with the two Docker commands under Usage.

## What's new in this fork

**143 new steps.** 16 are classic languages restored from mame's retired Ubuntu relays. Five count as relay steps but not as new languages (`mksh`, `BusyBox ash`, `yash`, `Chicken Scheme`, `Chez Scheme`):

Simula, Oberon, Euphoria, ALGOL 60, K (ngn/k), ChucK, dash, groff, Hy, Jsonnet, newLISP, NQP, PicoLisp, Racket, SQL (SQLite), AspectC++, Parrot asm (PASM), xonsh, mksh, BusyBox ash, Arturo, yash, YueScript, Elvish, Rocq, Lean 4, Idris 2, V, Hare, C3, Nelua, Zig, PowerShell, Nushell, Ion, YSH, Murex, Hush, es, Boo, VHDL, Genie, Nix, XQuery, Pkl, Koto, CUE, Macaulay2, Dart, Anko, Tengo, Nickel, Rhai, ><> (Fish), Hexagony, ///, CJam, Underload, Brain-Flak, Singular, Nial, Uiua, BQN, Fantom, Golo, Ballerina, Yeti, Gosu, Frege, J, Starlark, Teal, Umka, F*, MoonScript, Rego, Mathics, Berry, Pyth, Emmental, ArnoldC, LFE, Joy, Factor, Numbat, Frink, Ring, Janet, Io, Picat, CLIPS, Wren, PureScript, Pyret, ReScript, Wisp, Imba, Dafny, Julia, Maxima, Gri, UCBLogo, GNU Smalltalk, TXR, Gravity, Klong, GSL (Generator Scripting Language), Seed7, nesC, Lisaac, eC, CDuce, A+, Falcon, Coconut, Gleam, Roc, Inko, Koka, Chapel, Pony, Odin, rep (librep), Chicken Scheme, Rockstar, Chez Scheme, Mercury, Logtalk, Agda, Rail, Kipple, Beatnik, Glass, Taxi, Deadfish~, SNOBOL4, Ink, Uxntal, MMIX, 6502 asm, ARM64 asm, Z80 asm, RISC-V asm.

[RELAY-267.md](RELAY-267.md) explains how 267 steps fit in one Ruby file without overflowing compilers, VMs or memory.

## Records

We count under two rules, published in [RECORDS.md](RECORDS.md) so anyone can check or challenge them:

- **Tier 1, distinct languages:** each language counts once, whatever the version, dialect or implementation. This relay counts **257** (mame's 128 counts 123).
- **Tier 2, relay steps:** every step runs on its own real interpreter or compiler with its own source file, with at most 3 steps per language family. This relay counts **267**.

[LANGUAGES.md](LANGUAGES.md) lists every step with its tier.

## Usage

### Docker (recommended)

    $ docker build -t qr .
    $ docker run --rm qr

This installs every Ubuntu package, builds all source/release toolchains and bundled interpreters in `vendor/`, runs all 267 steps in order, and verifies `QR2.rb == QR.rb`.

### Ubuntu 26.04

#### 1. Install the Ubuntu packages and extra toolchains.

    $ sudo apt-get install afnix agda algol68g aspectc++ aspectj asymptote \
      ats2-lang basex bash bc bsh busybox-static chezscheme chicken-bin \
      chuck clips clisp clojure cmake coffeescript coq crystal dash dc \
      default-jdk-headless dhall dotnet-sdk-10.0 elixir elvish emacs-nox \
      erlang erlang-nox execline f2c fennel fish flex fp-compiler g++ \
      gambas3-gb-pcre gambas3-scripter gap gawk gcc gcc-aarch64-linux-gnu \
      gcc-riscv64-linux-gnu gdb gdc generator-scripting-language genius \
      gforth gfortran ghc ghdl ghostscript gm2 gnat gnucobol4 gnuplot gobjc \
      golang gpt gri groff groovy guile-3.0 gzip hare haxe hy icont iconx \
      intercal iverilog jasmin-sable jq jsonnet kotlin ksh libevent-dev \
      libpolyml-dev livescript llvm lua5.3 m4 macaulay2 make maxima minizinc \
      mksh mono-devel nasm neko newlisp nickle nim nix-bin node-typescript \
      nodejs nqp ocaml octave openjdk-25-jdk pari-gp parser3-cgi perl \
      php-cli picolisp pike8.0 polyml python3 qemu-user r-base racket rakudo \
      ratfor rc regina-rexx rep ruby ruby-mustache rustc scala singular spin \
      sqlite3 squirrel3 surgescript swi-prolog swiftlang tcl tcsh valac vim \
      wabt xa65 xonsh xsltproc yabasic yash yorick z80asm zoem zsh

For the remaining languages installed from pinned releases, cargo, Go, npm, pip, LuaRocks, or source tarballs, see [`Dockerfile`](Dockerfile) (generated from [`src/Dockerfile.gen.rb`](src/Dockerfile.gen.rb) and [`src/extra-installs/`](src/extra-installs/)).

Then build the bundled interpreters:

    $ sudo apt-get install cmake libpng-dev libgd-dev libfl-dev groff bison curl
    $ make -C vendor

#### 2. Run each program on each interpreter/compiler.

    $ ulimit -s unlimited
    $ ruby QR.rb > QR.sim
    $ rm -f QR QR.c && cim -q QR.sim >/dev/null 2>&1 && ./QR > QR.obn &&
      rm -f QR QR.c
    $ rm -rf QR .obnc && obnc QR.obn >/dev/null && ./QR > QR.ex && rm -rf QR .obnc
    $ eui QR.ex > QR.alg
    $ marst QR.alg -o QR.alg.c && gcc QR.alg.c -lalgol -lm -o QR && ./QR > QR.k.k &&
      rm -f QR QR.alg.c
    $ ngnk QR.k.k < /dev/null > QR.ck
    $ chuck --silent QR.ck > QR.dash
    $ dash QR.dash > QR.roff
    $ groff -z QR.roff 2> QR.hy
    $ hy QR.hy > QR.jsonnet
    $ jsonnet -S QR.jsonnet > QR.nl
    $ newlisp -n QR.nl > QR.nqp
    $ nqp QR.nqp > QR.l
    $ pil QR.l > QR.rkt
    $ racket QR.rkt > QR.sql
    $ sqlite3 < QR.sql > QR.cc
    $ ag++ --keywords -o QR QR.cc && ./QR > QR.pasm
    $ parrot QR.pasm > QR.xsh
    $ xonsh --no-rc QR.xsh > QR.mksh
    $ mksh QR.mksh > QR.bbash
    $ busybox ash QR.bbash > QR.art
    $ arturo QR.art < /dev/null > QR.yash
    $ yash QR.yash > QR.yue
    $ yue -e QR.yue > QR.elv
    $ elvish QR.elv > QR_rocq.v
    $ coqc QR_rocq.v && ocaml QR_rocq.ml > QR.lean && rm -f QR_rocq.ml QR_rocq.mli QR_rocq.vo QR_rocq.vok QR_rocq.vos QR_rocq.glob
    $ lean --run QR.lean > QR.idr
    $ idris2 --exec main QR.idr > QR.vlang.v
    $ v run QR.vlang.v > QR.ha
    $ hare build -q -o QR QR.ha && ./QR > QR.c3
    $ c3c compile QR.c3 -o QR && ./QR > QR.nelua
    $ nelua --no-cache QR.nelua > QR.zig
    $ zig run QR.zig > QR.ps1
    $ DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 POWERSHELL_TELEMETRY_OPTOUT=1 pwsh -NoProfile -NonInteractive -File QR.ps1 > QR.nu
    $ nu --no-config-file QR.nu > QR.ion
    $ ion QR.ion > QR.ysh
    $ ysh QR.ysh > QR.mx
    $ murex QR.mx > QR.hsh
    $ hush QR.hsh < /dev/null > QR.es
    $ es QR.es > QR.boo
    $ booi QR.boo > QR.vhdl
    $ ghdl -a QR.vhdl && ghdl -e qr && ghdl -r qr > QR.genie.gs
    $ valac QR.genie.gs && ./QR.genie > QR.nix
    $ nix eval --extra-experimental-features nix-command --raw --file QR.nix > QR.xq
    $ basex QR.xq > QR.pkl
    $ pkl eval QR.pkl > QR.koto
    $ koto QR.koto > QR.cue
    $ cue export --out text QR.cue > QR.m2
    $ M2 --script QR.m2 > QR.dart
    $ dart run QR.dart > QR.ank
    $ anko QR.ank > QR.tengo
    $ tengo QR.tengo > QR.ncl
    $ nickel export --format text QR.ncl > QR.rhai
    $ rhai-run QR.rhai > QR.rs
    $ rustc QR.rs && ./QR > QR.scala
    $ scalac QR.scala && scala QR > QR.scm
    $ guile QR.scm > QR.nut
    $ squirrel QR.nut > QR.sml
    $ polyc -o QR QR.sml && ./QR > QR.sq
    $ ruby vendor/subleq.rb QR.sq > QR.ss
    $ surgescript QR.ss > QR.swift
    $ swiftc QR.swift && ./QR > QR.tcl
    $ tclsh QR.tcl > QR.tcsh
    $ tcsh QR.tcsh > QR.t
    $ ruby vendor/thue.rb QR.t > QR.ts
    $ tsc --outFile QR.ts.js QR.ts && nodejs QR.ts.js > QR.unl
    $ ruby vendor/unlambda.rb QR.unl > QR.v
    $ iverilog -o QR QR.v && ./QR -vcd-none > QR.fish.fish
    $ python3 vendor/fish.py QR.fish.fish > QR.hxg
    $ ruby /opt/hexagony/interpreter.rb QR.hxg > QR.vim
    $ vim -EsS QR.vim > QR.vb
    $ echo '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><EnableDefaultCompileItems>false</EnableDefaultCompileItems></PropertyGroup><ItemGroup><Compile Include="QR.vb" /></ItemGroup></Project>' > tmp.vbproj &&
      DOTNET_NOLOGO=1 dotnet run --project tmp.vbproj > QR.wasm
    $ $(WASI_RUNTIME) QR.wasm > QR.wat
    $ wat2wasm QR.wat -o QR.wat.wasm && $(WASI_RUNTIME) QR.wat.wasm > QR.ws
    $ ruby vendor/whitespace.rb QR.ws > QR.xslt
    $ xsltproc QR.xslt > QR.slashes
    $ ruby vendor/slashes.rb QR.slashes > QR.cjam
    $ ruby vendor/cjam.rb QR.cjam > QR.ul
    $ ruby vendor/underload.rb QR.ul > QR.bflk
    $ ruby vendor/brain_flak.rb -A QR.bflk > QR.yab
    $ yabasic QR.yab > QR.yorick
    $ yorick -batch QR.yorick > QR.sing
    $ Singular -q QR.sing > QR.azm
    $ zoem -i QR.azm > QR.ndf
    $ nial -defs QR.ndf < /dev/null > QR.zsh
    $ zsh QR.zsh > QR.ua
    $ uiua run --no-format QR.ua > QR.bqn
    $ bqn QR.bqn > QR.fan
    $ fan QR.fan > QR.golo
    $ golo golo --files QR.golo > QR.bal
    $ bal run --offline QR.bal > QR.yeti
    $ yeti QR.yeti > QR.gsp
    $ gosu QR.gsp > QR.fr
    $ mkdir -p frege-out && frege -d frege-out QR.fr && java -cp frege-out:/usr/local/lib/frege.jar QR > qr.adb
    $ gnatmake qr.adb && ./qr > QR.als
    $ LANG=C LD_LIBRARY_PATH=/usr/lib/afnix axi QR.als > QR.aheui
    $ ruby vendor/aheui.rb QR.aheui > QR.ijs
    $ ijconsole QR.ijs < /dev/null > QR.a68
    $ a68g --heap 512M QR.a68 > QR.ante
    $ ruby vendor/ante.rb QR.ante > QR.star
    $ starlark QR.star 2> QR.aj
    $ ajc QR.aj && java QR > QR.tl
    $ tl run QR.tl > QR.asy
    $ asy QR.asy > QR.um
    $ umka QR.um > QR.fst
    $ fstar.exe --cache_checked_modules --cache_dir fst_out QR.fst > /dev/null &&
      fstar.exe --cache_dir fst_out --odir fst_out --codegen OCaml --custard_main QR.main QR.fst > /dev/null &&
      ocaml fst_out/Custard.ml > QR.dats
    $ patscc -o QR QR.dats && ./QR > QR.moon
    $ moon QR.moon > QR.awk
    $ awk -f QR.awk > QR.rego
    $ opa eval --format raw -d QR.rego data.qr.x > QR.wl
    $ mathics -q --no-completion -f QR.wl < /dev/null > QR.bash
    $ bash QR.bash > QR.bc
    $ BC_LINE_LENGTH=4000000 bc -q QR.bc > QR.be
    $ berry QR.be > QR.c
    $ gcc -o QR QR.c && ./QR > QR.cpp
    $ g++ -o QR QR.cpp && ./QR > QR.pyth
    $ python3 /opt/pyth/pyth.py -n QR.pyth > QR.emmental
    $ ruby vendor/emmental.rb QR.emmental > QR.arnoldc
    $ rm -f QR.class && java -jar /opt/ArnoldC.jar QR.arnoldc && java QR > QR.lfe &&
      rm -f QR.class
    $ lfe QR.lfe > QR.joy
    $ joy QR.joy > QR.factor
    $ /opt/factor/factor QR.factor > QR.nbt
    $ numbat QR.nbt > QR.cs
    $ echo '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><EnableDefaultCompileItems>false</EnableDefaultCompileItems></PropertyGroup><ItemGroup><Compile Include="QR.cs" /></ItemGroup></Project>' > tmp.csproj &&
      DOTNET_NOLOGO=1 dotnet run --project tmp.csproj > QR.chef
    $ PERL5LIB=vendor/local/lib/perl5 compilechef QR.chef QR.chef.pl &&
      perl QR.chef.pl > QR.frink
    $ java -cp /opt/frink/frink.jar frink.parser.Frink QR.frink > QR.clj
    $ clojure QR.clj > QR.cmake
    $ cmake -P QR.cmake > QR.cob
    $ cobc -O2 -x QR.cob && ./QR > QR.ring
    $ ring QR.ring > QR.coffee
    $ coffee --nodejs --stack_size=100000 QR.coffee > QR.lisp
    $ clisp QR.lisp > QR.cr
    $ crystal QR.cr > QR.d
    $ gdc -o QR QR.d && ./QR > QR.dc
    $ dc QR.dc > QR.dhall || true
    $ dhall text --file QR.dhall > QR.exs
    $ elixir QR.exs > QR.el
    $ emacs -Q --script QR.el > QR.erl
    $ escript QR.erl > QR.e
    $ execlineb QR.e > QR.fsx
    $ echo '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><OutputType>Exe</OutputType><TargetFramework>net10.0</TargetFramework><EnableDefaultCompileItems>false</EnableDefaultCompileItems></PropertyGroup><ItemGroup><Compile Include="QR.fsx" /></ItemGroup></Project>' > tmp.fsproj &&
      DOTNET_NOLOGO=1 dotnet run --project tmp.fsproj > QR.false
    $ ruby vendor/false.rb QR.false > QR.fnl
    $ fennel QR.fnl > QR.fl
    $ flex -o QR.fl.c QR.fl && gcc -o QR QR.fl.c && ./QR > QR.fish
    $ fish QR.fish > QR.fs
    $ gforth QR.fs > QR.f
    $ gfortran -o QR QR.f && ./QR > QR.f90
    $ gfortran -o QR QR.f90 && ./QR > QR.gbs
    $ gbs3 QR.gbs > QR.g
    $ gap -q QR.g > QR.gdb
    $ gdb -q -x QR.gdb > QR.gel
    $ genius QR.gel > QR.plt
    $ gnuplot QR.plt > QR.go
    $ go run QR.go > QR.gs
    $ ruby vendor/golfscript.rb QR.gs > QR.gpt
    $ mv QR.c QR.c.bak && gpt -t QR.c QR.gpt && gcc -o QR QR.c && ./QR > QR.grass &&
      mv QR.c.bak QR.c
    $ ruby vendor/grass.rb QR.grass > QR.janet
    $ janet QR.janet > QR.groovy
    $ groovy QR.groovy > QR.gz
    $ gzip -cd QR.gz > QR.io
    $ io QR.io > QR.hs
    $ rm -f QR.o && ghc QR.hs && ./QR > QR.pi
    $ picat QR.pi > QR.hx
    $ haxe -main QR -neko QR.n && neko QR.n > QR.clp
    $ clips -f2 QR.clp > QR.icn
    $ icont -s QR.icn && ./QR > QR.i
    $ ick -bfOc QR.i && gcc -std=c99 -static QR.c -I /usr/include/ick-* -o QR -lick &&
      ./QR > QR.wren
    $ wren_cli QR.wren > QR.j
    $ jasmin QR.j && java QR > QR.purs
    $ purs compile -o /opt/purs/out QR.purs '/opt/purs/lib/*/src/**/*.purs' &&
      node /opt/purs/out/QR/index.js > QR.arr
    $ pyretc QR.arr QR.jarr && NODE_PATH=/opt/b05/node_modules node QR.jarr > QR.res
    $ bsc QR.res > QR.res.js && node QR.res.js > QR.wisp
    $ wisp < QR.wisp > QR.wisp.js && node QR.wisp.js > QR.imba
    $ imba QR.imba > QR.dfy
    $ dafny build -o dafny-out/QR QR.dfy && DOTNET_ROLL_FORWARD=Major dotnet dafny-out/QR.dll > QR.jl
    $ julia QR.jl > QR.mac
    $ maxima -q --init-mac=QR.mac > QR.gri
    $ gri QR.gri > QR.logo
    $ ucblogo QR.logo > QR.java
    $ javac QR.java && java QR > QR.st
    $ gst QR.st > QR.js
    $ nodejs QR.js > QR.jq
    $ jq -r -n -f QR.jq > QR.jsfuck
    $ nodejs --stack_size=100000 QR.jsfuck > QR.kt
    $ kotlinc QR.kt -include-runtime -d QR.jar && kotlin QR.jar > QR.txrlisp
    $ txr --lisp QR.txrlisp > QR.gravity
    $ gravity -q QR.gravity > QR.kg
    $ kg QR.kg < /dev/null > QR.gsl
    $ gsl -q QR.gsl > QR.sd7
    $ s7 -q QR.sd7 > QR.nc
    $ nescc -gcc=gcc-14 -o QR QR.nc && ./QR > QR.ll
    $ llvm-as QR.ll && lli QR.bc > QR.lol
    $ lci QR.lol > QR.lua
    $ lua5.3 QR.lua > qr.li
    $ lisaac -gcc -Wno-implicit-function-declaration qr.li > /dev/null &&
      ./qr > QR_ec.ec
    $ ecp -c QR_ec.ec -o QR_ec.sym && ecc -c QR_ec.ec -o QR_ec.c && ecs -console QR_ec.sym QR_ec.imp -o QR_ec.main.ec &&
      ecp -c QR_ec.main.ec -o QR_ec.main.sym && ecc -c QR_ec.main.ec -o QR_ec.main.c &&
      gcc -std=gnu17 -w -o QR_ec QR_ec.c QR_ec.main.c -lecereCOM &&
      ./QR_ec > QR.cd
    $ cduce QR.cd > QR.aplus.a
    $ a+ QR.aplus.a > QR.m4 2> /dev/null < /dev/null
    $ m4 QR.m4 > QR.mk
    $ make -f QR.mk > QR.mzn
    $ minizinc --solver COIN-BC --soln-sep '' QR.mzn > QR.mod
    $ gm2 -fiso QR.mod -o QR && ./QR > QR.il
    $ ilasm QR.il && mono QR.exe > QR.php
    $ php QR.php > QR.png
    $ npiet QR.png > QR.mustache
    $ mustache QR.mustache QR.mustache > QR.asm
    $ nasm -felf QR.asm && ld -m elf_i386 -o QR QR.o && ./QR > QR.neko
    $ nekoc QR.neko && neko QR.n > QR.5c
    $ nickle QR.5c > QR.nim
    $ nim compile QR.nim && ./QR > QR.m
    $ gcc -o QR QR.m && ./QR > QR.ml
    $ ocaml QR.ml > QR.fal
    $ falcon QR.fal > QR.vala
    $ valac QR.vala && ./QR > QR.mid
    $ mono vendor/local/bin/Vlt.exe /s QR.mid && mono QR.exe > QR.coco
    $ coconut -q -r QR.coco > QR.octave
    $ mv QR.m QR.m.bak && octave -qf QR.octave > QR.ook && mv QR.m.bak QR.m
    $ ruby vendor/ook-to-bf.rb QR.ook QR.ook.bf && ruby vendor/bf.rb QR.ook.bf > QR.gp
    $ gp -f -q QR.gp > QR.gleam
    $ mkdir -p qrgleam/src && cp QR.gleam qrgleam/src/qr.gleam && printf 'name = "qr"\nversion = "1.0.0"\n' > qrgleam/gleam.toml &&
      (cd qrgleam; gleam run --no-print-progress) > QR.roc
    $ roc build --output qrroc QR.roc && ./qrroc > QR.inko
    $ inko run QR.inko > qr.kk
    $ koka -v0 -o qrkoka qr.kk && chmod +x qrkoka && ./qrkoka > QR.chpl
    $ chpl -o qrchpl QR.chpl && ./qrchpl > QR.pony
    $ mkdir -p qrpony && cp QR.pony qrpony/main.pony && ponyc -V0 -b qrpony.out -o . qrpony &&
      ./qrpony.out > QR.odin
    $ odin run QR.odin -file > QR.rep
    $ rep QR.rep > QR.chicken.scm
    $ csi -q -s QR.chicken.scm > QR.rock
    $ rockstar QR.rock > QR.chez.ss
    $ chezscheme --script QR.chez.ss > QR.p
    $ parser3 QR.p > QR.pas
    $ fpc QR.pas && ./QR > QR.pl
    $ perl QR.pl > QR.pl6
    $ perl6 QR.pl6 > qr_mercury.m
    $ mmc --make qr_mercury > /dev/null && ./qr_mercury > QR.pike
    $ pike QR.pike > settings.lgt
    $ swilgt -q < /dev/null > QR.ps
    $ gs -dNODISPLAY -q QR.ps > QR.agda
    $ agda --compile --compile-dir=agda_out QR.agda > /dev/null && ./agda_out/QR > QR.prolog
    $ swipl -q -t qr -f QR.prolog > QR.pr
    $ spin -T QR.pr > QR.rail
    $ rail QR.rail > QR.kpl
    $ cipple QR.kpl > QR.beatnik
    $ ruby vendor/beatnik.rb QR.beatnik > QR.glass
    $ ruby vendor/glass.rb QR.glass > QR.taxi
    $ taxi QR.taxi > QR.dft
    $ ruby vendor/deadfish_tilde.rb QR.dft > QR.sno
    $ snobol4 -b QR.sno > QR.ink
    $ inklecate -p QR.ink > QR.tal
    $ uxnasm QR.tal QR.rom && uxncli QR.rom > QR.mms && rm -f QR.rom
    $ mmixal -b 2000000 -o QR.mmo QR.mms && mmix QR.mmo > QR.s65 && rm -f QR.mmo
    $ xa -o QR.o65 QR.s65 && python3 vendor/run6502.py QR.o65 > QR.arm64.s
    $ rm -f QR && aarch64-linux-gnu-gcc -nostdlib -static -o QR QR.arm64.s &&
      qemu-aarch64 ./QR > QR.z80 && rm -f QR
    $ z80asm QR.z80 -o QR.z80.bin && python3 vendor/runz80.py QR.z80.bin > QR.rv.s
    $ rm -f QR && riscv64-linux-gnu-gcc -nostdlib -static -o QR QR.rv.s &&
      qemu-riscv64 ./QR > QR.bsh && rm -f QR
    $ bsh QR.bsh > QR.bef
    $ cfunge QR.bef > QR.Blc
    $ ruby vendor/blc.rb < QR.Blc > QR.bf
    $ ruby vendor/bf.rb QR.bf > QR.ksh
    $ ksh QR.ksh > QR.lazy
    $ lazyk QR.lazy > QR.ls
    $ lsc QR.ls > QR.py
    $ python3 QR.py > QR.R
    $ R --slave -f QR.R > QR.ratfor
    $ ratfor -o QR.ratfor.f QR.ratfor && gfortran -o QR QR.ratfor.f &&
      ./QR > QR.rc
    $ rc QR.rc > QR.rexx
    $ rexx ./QR.rexx > QR2.rb

You will see that `QR.rb` is byte-for-byte identical to `QR2.rb`:

    $ diff -s QR.rb QR2.rb

Or just run `make check`:

    $ make check

## Languages and packages

\#  |language                           |ubuntu package (or how to get it)                     |added in
----|-----------------------------------|------------------------------------------------------|--------------
1   |Ruby                               |ruby                                                  |mame
2   |Simula                             |`GNU Cim 5.1 source tarball`                          |**this fork**
3   |Oberon                             |`OBNC 0.17.2 source tarball`                          |**this fork**
4   |Euphoria                           |`OpenEuphoria 4.1.0 release`                          |**this fork**
5   |ALGOL 60                           |`GNU MARST 2.8 source tarball`                        |**this fork**
6   |K (ngn/k)                          |`codeberg.org/ngn/k (clang build)`                    |**this fork**
7   |ChucK                              |chuck                                                 |**this fork**
8   |dash                               |dash                                                  |**this fork**
9   |groff                              |groff                                                 |**this fork**
10  |Hy                                 |hy                                                    |**this fork**
11  |Jsonnet                            |jsonnet                                               |**this fork**
12  |newLISP                            |newlisp                                               |**this fork**
13  |NQP                                |nqp                                                   |**this fork**
14  |PicoLisp                           |picolisp                                              |**this fork**
15  |Racket                             |racket                                                |**this fork**
16  |SQL (SQLite)                       |sqlite3                                               |**this fork**
17  |AspectC++                          |aspectc++                                             |**this fork**
18  |Parrot asm (PASM)                  |`Parrot 8.1.0 source build`                           |**this fork**
19  |xonsh                              |xonsh                                                 |**this fork**
20  |mksh                               |mksh                                                  |**this fork**
21  |BusyBox ash                        |busybox-static                                        |**this fork**
22  |Arturo                             |`Arturo v0.10.0 release`                              |**this fork**
23  |yash                               |yash                                                  |**this fork**
24  |YueScript                          |`YueScript v0.34.3 source build`                      |**this fork**
25  |Elvish                             |elvish                                                |**this fork**
26  |Rocq                               |coq                                                   |**this fork**
27  |Lean 4                             |`Lean v4.35.0 release`                                |**this fork**
28  |Idris 2                            |`Idris2 v0.8.0 source build`                          |**this fork**
29  |V                                  |`V 0.4.12 release`                                    |**this fork**
30  |Hare                               |hare                                                  |**this fork**
31  |C3                                 |`c3c v0.7.0 release`                                  |**this fork**
32  |Nelua                              |`nelua-lang source build`                             |**this fork**
33  |Zig                                |`Zig 0.13.0 release`                                  |**this fork**
34  |PowerShell                         |`PowerShell v7.4.6 release`                           |**this fork**
35  |Nushell                            |`Nushell 0.101.0 release`                             |**this fork**
36  |Ion                                |`cargo install ion-shell`                             |**this fork**
37  |YSH                                |`Oils for Unix 0.24.0 source tarball`                 |**this fork**
38  |Murex                              |`Murex v7.4.2002 (Go build)`                          |**this fork**
39  |Hush                               |`cargo install hush@0.1.4`                            |**this fork**
40  |es                                 |`es-shell v0.9.2 source tarball`                      |**this fork**
41  |Boo                                |`Ubuntu archive boo 0.9.5 (.deb)`                     |**this fork**
42  |VHDL                               |ghdl                                                  |**this fork**
43  |Genie                              |valac                                                 |**this fork**
44  |Nix                                |nix-bin                                               |**this fork**
45  |XQuery                             |basex                                                 |**this fork**
46  |Pkl                                |`Apple Pkl 0.33.0 release`                            |**this fork**
47  |Koto                               |`cargo install koto_cli@0.16.1`                       |**this fork**
48  |CUE                                |`go install cuelang.org/go/cmd/cue@v0.17.1`           |**this fork**
49  |Macaulay2                          |macaulay2                                             |**this fork**
50  |Dart                               |`Dart SDK 3.14.0 release`                             |**this fork**
51  |Anko                               |`go install github.com/mattn/anko@v0.1.15`            |**this fork**
52  |Tengo                              |`go install github.com/d5/tengo/v2/cmd/tengo@v2.17.0` |**this fork**
53  |Nickel                             |`cargo install nickel-lang-cli@1.18.0`                |**this fork**
54  |Rhai                               |`cargo install rhai@1.27.0`                           |**this fork**
55  |Rust                               |rustc                                                 |mame
56  |Scala                              |scala                                                 |mame
57  |Scheme                             |guile-3.0                                             |mame
58  |Squirrel                           |squirrel3                                             |mame
59  |Standard ML                        |polyml, libpolyml-dev                                 |mame
60  |Subleq                             |*bundled in vendor/*                                  |mame
61  |SurgeScript                        |surgescript                                           |mame
62  |Swift                              |swiftlang                                             |mame
63  |Tcl                                |tcl                                                   |mame
64  |tcsh                               |tcsh                                                  |mame
65  |Thue                               |*bundled in vendor/*                                  |mame
66  |TypeScript                         |node-typescript                                       |mame
67  |Unlambda                           |*bundled in vendor/*                                  |mame
68  |Verilog                            |iverilog                                              |mame
69  |><> (Fish)                         |*bundled in vendor/*                                  |**this fork**
70  |Hexagony                           |`m-ender/hexagony (official Ruby interpreter)`        |**this fork**
71  |Vimscript                          |vim                                                   |mame
72  |Visual Basic                       |dotnet-sdk-10.0                                       |mame
73  |WebAssembly (Binary format)        |wabt                                                  |mame
74  |WebAssembly (Text format)          |wabt                                                  |mame
75  |Whitespace                         |*bundled in vendor/*                                  |mame
76  |XSLT                               |xsltproc                                              |mame
77  |///                                |*bundled in vendor/*                                  |**this fork**
78  |CJam                               |*bundled in vendor/*                                  |**this fork**
79  |Underload                          |*bundled in vendor/*                                  |**this fork**
80  |Brain-Flak                         |*bundled in vendor/*                                  |**this fork**
81  |Yabasic                            |yabasic                                               |mame
82  |Yorick                             |yorick                                                |mame
83  |Singular                           |singular                                              |**this fork**
84  |Zoem                               |zoem                                                  |mame
85  |Nial                               |`Q'Nial nialcore source build`                        |**this fork**
86  |zsh                                |zsh                                                   |mame
87  |Uiua                               |`cargo install uiua@0.19.1`                           |**this fork**
88  |BQN                                |`CBQN v0.9.0 (clang build)`                           |**this fork**
89  |Fantom                             |`Fantom v1.0.84 release`                              |**this fork**
90  |Golo                               |`Eclipse Golo 3.4.0 release`                          |**this fork**
91  |Ballerina                          |`Ballerina 2201.14.1 (.deb)`                          |**this fork**
92  |Yeti                               |`Yeti ML source build (ant)`                          |**this fork**
93  |Gosu                               |`Gosu 1.18.14 Maven release`                          |**this fork**
94  |Frege                              |`Frege 3.25.84 jar release`                           |**this fork**
95  |Ada                                |gnat                                                  |mame
96  |AFNIX                              |afnix                                                 |mame
97  |Aheui                              |*bundled in vendor/*                                  |mame
98  |J                                  |`J 9.7 release`                                       |**this fork**
99  |ALGOL 68                           |algol68g                                              |mame
100 |Ante                               |*bundled in vendor/*                                  |mame
101 |Starlark                           |`go install go.starlark.net/cmd/starlark`             |**this fork**
102 |AspectJ                            |aspectj                                               |mame
103 |Teal                               |`luarocks install tl 0.24.8-1`                        |**this fork**
104 |Asymptote                          |asymptote                                             |mame
105 |Umka                               |`Umka v1.5.7 source build`                            |**this fork**
106 |F*                                 |`FStar v2026.10.25 release`                           |**this fork**
107 |ATS                                |ats2-lang                                             |mame
108 |MoonScript                         |`luarocks install moonscript 0.5.0-1`                 |**this fork**
109 |Awk                                |gawk                                                  |mame
110 |Rego                               |`Open Policy Agent v1.22.4 release`                   |**this fork**
111 |Mathics                            |`pip install mathics3==10.0.1`                        |**this fork**
112 |bash                               |bash                                                  |mame
113 |bc                                 |bc                                                    |mame
114 |Berry                              |`Berry v1.1.0 source build`                           |**this fork**
115 |C                                  |gcc                                                   |mame
116 |C++                                |g++                                                   |mame
117 |Pyth                               |`isaacg1/pyth git release + python3`                  |**this fork**
118 |Emmental                           |*bundled in vendor/*                                  |**this fork**
119 |ArnoldC                            |`ArnoldC.jar + default-jdk-headless`                  |**this fork**
120 |LFE                                |erlang-nox                                            |**this fork**
121 |Joy                                |`Joy source build`                                    |**this fork**
122 |Factor                             |`Factor 0.100 release`                                |**this fork**
123 |Numbat                             |`cargo install numbat-cli@1.24.0`                     |**this fork**
124 |C#                                 |dotnet-sdk-10.0                                       |mame
125 |Chef                               |*bundled in vendor/*                                  |mame
126 |Frink                              |*bundled in vendor/*                                  |**this fork**
127 |Clojure                            |clojure                                               |mame
128 |CMake                              |cmake                                                 |mame
129 |Cobol                              |gnucobol4                                             |mame
130 |Ring                               |`Ring v1.27 source build`                             |**this fork**
131 |CoffeeScript                       |coffeescript                                          |mame
132 |Common Lisp                        |clisp                                                 |mame
133 |Crystal                            |crystal, libevent-dev                                 |mame
134 |D                                  |gdc                                                   |mame
135 |dc                                 |dc                                                    |mame
136 |Dhall                              |dhall                                                 |mame
137 |Elixir                             |elixir                                                |mame
138 |Emacs Lisp                         |emacs-nox                                             |mame
139 |Erlang                             |erlang                                                |mame
140 |Execline                           |execline                                              |mame
141 |F#                                 |dotnet-sdk-10.0                                       |mame
142 |FALSE                              |*bundled in vendor/*                                  |mame
143 |Fennel                             |fennel                                                |mame
144 |Flex                               |flex                                                  |mame
145 |Fish                               |fish                                                  |mame
146 |Forth                              |gforth                                                |mame
147 |FORTRAN77                          |f2c                                                   |mame
148 |Fortran90                          |gfortran                                              |mame
149 |Gambas script                      |gambas3-scripter, gambas3-gb-pcre                     |mame
150 |GAP                                |gap                                                   |mame
151 |GDB                                |gdb                                                   |mame
152 |GEL (Genius)                       |genius                                                |mame
153 |Gnuplot                            |gnuplot                                               |mame
154 |Go                                 |golang                                                |mame
155 |GolfScript                         |*bundled in vendor/*                                  |mame
156 |G-Portugol                         |gpt                                                   |mame
157 |Grass                              |*bundled in vendor/*                                  |mame
158 |Janet                              |`Janet v1.43.0 source build`                          |**this fork**
159 |Groovy                             |groovy                                                |mame
160 |Gzip                               |gzip                                                  |mame
161 |Io                                 |`Io 2019.05.22 source build`                          |**this fork**
162 |Haskell                            |ghc                                                   |mame
163 |Picat                              |`Picat 3.9#12 release`                                |**this fork**
164 |Haxe                               |haxe                                                  |mame
165 |CLIPS                              |clips                                                 |**this fork**
166 |Icon                               |icont, iconx                                          |mame
167 |INTERCAL                           |intercal                                              |mame
168 |Wren                               |`Wren CLI 0.4.0 source build`                         |**this fork**
169 |Jasmin                             |jasmin-sable                                          |mame
170 |PureScript                         |`npm install purescript@0.15.17`                      |**this fork**
171 |Pyret                              |`npm install pyret-npm@0.1.29`                        |**this fork**
172 |ReScript                           |`npm install rescript@12.3.1`                         |**this fork**
173 |Wisp                               |`npm install wisp@0.13.0`                             |**this fork**
174 |Imba                               |`npm install imba@2.0.0-alpha.253`                    |**this fork**
175 |Dafny                              |`Dafny v4.11.0 release`                               |**this fork**
176 |Julia                              |`Julia 1.13.4 release`                                |**this fork**
177 |Maxima                             |maxima                                                |**this fork**
178 |Gri                                |gri                                                   |**this fork**
179 |UCBLogo                            |`UCBLogo 6.2.5 source tarball`                        |**this fork**
180 |Java                               |openjdk-25-jdk                                        |mame
181 |GNU Smalltalk                      |`GNU Smalltalk 3.2.5 source tarball`                  |**this fork**
182 |JavaScript                         |nodejs                                                |mame
183 |Jq                                 |jq                                                    |mame
184 |JSFuck                             |nodejs                                                |mame
185 |Kotlin                             |kotlin                                                |mame
186 |TXR                                |`TXR 302 source tarball`                              |**this fork**
187 |Gravity                            |`Gravity 0.9.9 source build`                          |**this fork**
188 |Klong                              |`Klong 20221212 source tarball`                       |**this fork**
189 |GSL (Generator Scripting Language) |generator-scripting-language                          |**this fork**
190 |Seed7                              |`Seed7 2026-07-11 source build`                       |**this fork**
191 |nesC                               |`nesC v1.4.0 source build`                            |**this fork**
192 |LLVM asm                           |llvm                                                  |mame
193 |LOLCODE                            |*bundled in vendor/*                                  |mame
194 |Lua                                |lua5.3                                                |mame
195 |Lisaac                             |`Ubuntu archive lisaac 0.39 (.deb)`                   |**this fork**
196 |eC                                 |`Ubuntu archive ecere-sdk 0.44.15 (.deb)`             |**this fork**
197 |CDuce                              |`Ubuntu archive cduce 0.6.0 (.deb)`                   |**this fork**
198 |A+                                 |`Ubuntu archive aplus-fsf 4.22.1 (.deb)`              |**this fork**
199 |M4                                 |m4                                                    |mame
200 |Makefile                           |make                                                  |mame
201 |MiniZinc                           |minizinc                                              |mame
202 |Modula-2                           |gm2                                                   |mame
203 |MSIL                               |mono-devel                                            |mame
204 |PHP                                |php-cli                                               |mame
205 |Piet                               |*bundled in vendor/*                                  |mame
206 |Mustache                           |ruby-mustache                                         |mame
207 |NASM                               |nasm                                                  |mame
208 |Neko                               |neko                                                  |mame
209 |Nickle                             |nickle                                                |mame
210 |Nim                                |nim                                                   |mame
211 |Objective-C                        |gobjc                                                 |mame
212 |OCaml                              |ocaml                                                 |mame
213 |Falcon                             |`Ubuntu archive falconpl 0.9.6.9 (.deb)`              |**this fork**
214 |Vala                               |valac                                                 |mame
215 |Velato                             |*bundled in vendor/*                                  |mame
216 |Coconut                            |`pip install coconut==3.2.0`                          |**this fork**
217 |Octave                             |octave                                                |mame
218 |Ook!                               |*bundled in vendor/*                                  |mame
219 |PARI/GP                            |pari-gp                                               |mame
220 |Gleam                              |`Gleam v1.19.2 release`                               |**this fork**
221 |Roc                                |`Roc alpha4-rolling release`                          |**this fork**
222 |Inko                               |`Inko v0.21.1 source build`                           |**this fork**
223 |Koka                               |`Koka v3.2.9 release`                                 |**this fork**
224 |Chapel                             |`Chapel 2.10.0 (.deb)`                                |**this fork**
225 |Pony                               |`ponyc 0.78.2 release`                                |**this fork**
226 |Odin                               |`Odin dev-2026-10 release`                            |**this fork**
227 |rep (librep)                       |rep                                                   |**this fork**
228 |Chicken Scheme                     |chicken-bin                                           |**this fork**
229 |Rockstar                           |`Rockstar v2.0.15 release`                            |**this fork**
230 |Chez Scheme                        |chezscheme                                            |**this fork**
231 |Parser 3                           |parser3-cgi                                           |mame
232 |Pascal                             |fp-compiler                                           |mame
233 |Perl 5                             |perl                                                  |mame
234 |Perl 6                             |rakudo                                                |mame
235 |Mercury                            |`Mercury 22.01.8 apt repository`                      |**this fork**
236 |Pike                               |pike8.0                                               |mame
237 |Logtalk                            |`Logtalk 3.102.0 (.deb)`                              |**this fork**
238 |PostScript                         |ghostscript                                           |mame
239 |Agda                               |agda                                                  |**this fork**
240 |Prolog                             |swi-prolog                                            |mame
241 |Promela (Spin)                     |spin                                                  |mame
242 |Rail                               |`TryItOnline/rail C++ build`                          |**this fork**
243 |Kipple                             |`cipple 0.2.1 C build`                                |**this fork**
244 |Beatnik                            |*bundled in vendor/*                                  |**this fork**
245 |Glass                              |*bundled in vendor/*                                  |**this fork**
246 |Taxi                               |`BigZaphod Taxi C++ build`                            |**this fork**
247 |Deadfish~                          |*bundled in vendor/*                                  |**this fork**
248 |SNOBOL4                            |`CSNOBOL4 2.3 source tarball`                         |**this fork**
249 |Ink                                |`Inklecate v1.2.1 release`                            |**this fork**
250 |Uxntal                             |`Uxn uxnasm + uxncli C build`                         |**this fork**
251 |MMIX                               |`Knuth MMIXware source build`                         |**this fork**
252 |6502 asm                           |xa65                                                  |**this fork**
253 |ARM64 asm                          |gcc-aarch64-linux-gnu, qemu-user                      |**this fork**
254 |Z80 asm                            |z80asm                                                |**this fork**
255 |RISC-V asm                         |gcc-riscv64-linux-gnu, qemu-user                      |**this fork**
256 |BeanShell                          |bsh                                                   |mame
257 |Befunge                            |*bundled in vendor/*                                  |mame
258 |BLC8                               |*bundled in vendor/*                                  |mame
259 |Brainfuck                          |*bundled in vendor/*                                  |mame
260 |ksh                                |ksh                                                   |mame
261 |Lazy K                             |*bundled in vendor/*                                  |mame
262 |LiveScript                         |livescript                                            |mame
263 |Python                             |python3                                               |mame
264 |R                                  |r-base                                                |mame
265 |Ratfor                             |ratfor                                                |mame
266 |rc                                 |rc                                                    |mame
267 |REXX                               |regina-rexx                                           |mame

Languages marked *bundled in vendor/* have interpreters included in `vendor/`; see [`vendor/README`](vendor/README) for licenses and details.

## Frequently asked questions

### Q. Who made this?

A. The original 128-language relay, its uroboros code generator, and the core compression architecture are by [Yusuke Endoh (mame)](https://github.com/mame). This fork extends the relay to 267 steps (257 distinct languages), reworks the escaping and compression so the text survives 267 layers, follows mame's no-cheating rules, and documents the record rules. Built by [Drawn With Code](https://www.youtube.com/@DrawnWithCode).

### Q. How does a quine relay work?

A. mame explains the original design in ["The World of Obfuscated, Esoteric, Artistic Programming"](http://gihyo.jp/book/2015/978-4-7741-7643-7) (in Japanese), and [RELAY-267.md](RELAY-267.md) covers how this fork scales the loop to 267 steps.

### Q. Language XXX is missing!

A. Pull requests are welcome! Every added step must run on its real compiler or interpreter inside the Docker image and close the full loop with zero stand-ins. See [RECORDS.md](RECORDS.md).

### Q. The code does not fit on my screen!

A. [Here is the 1-pixel-per-bit bitmap of `QR.rb`][thumbnail].

[thumbnail]: thumbnail.png

### Q. How was the code generated?

A.

    $ cd src
    $ rake

`src/code-gen.rb` defines all 267 steps. `rake` rebuilds `QR.rb`, `Makefile`, `Dockerfile`, `LANGUAGES.md`, the CI workflow, and this `README.md`. `src/langs.png.gen.rb` renders `langs.png`, and `src/thumbnail.png.gen.rb` renders `thumbnail.png`.

## History

### This fork

- **267 steps / 257 distinct languages, Ubuntu 26.04 (Nov 19, 2026).** This repo. Rebuilt under mame's no-cheating rules after his feedback on the 284-step fork.
- **284 steps (Nov 18, 2026), withdrawn.** Published at [exacortex/quine-relay-284](https://github.com/exacortex/quine-relay-284). Some of its steps read their own source, passed code on the command line or wrote output through files, so we don't count it.
- **151 steps / 143 distinct languages, Ubuntu 26.04 (Nov 13, 2026).** Published at [exacortex/quine-relay-151](https://github.com/exacortex/quine-relay-151).

### mame's Quine Relay

- **50 -> 64 -> 100 -> 128 languages (Ubuntu 13.04 through Ubuntu 26.04):** [mame/quine-relay](https://github.com/mame/quine-relay).

## License

The MIT License applies to all resources
*except* the files in the `vendor/` directory.

The files in the `vendor/` directory are from third-parties (or self-made esolang runners)
and are distributed under their respective licenses.
See [`vendor/README`](vendor/README) in detail.

---

The MIT License (MIT)

Copyright (c) 2013–2026 Yusuke Endoh (@mametter), @hirekoke
Copyright (c) 2026 Drawn With Code (@exacortex / @rasteia): the steps and scale architecture added in this fork

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
