# No-cheat pass (Nov 18, 2026)

Yusuke Endoh (mame) looked at the 284-step fork and named three things he treats as cheating in a quine relay.
This pass removes all three from every step.

## The rules

1. **No code on the command line.** A step's command may name the program file and set compiler or interpreter
   options. It may not carry program text (`node -e '...'`, a `printf` that prepends code, and so on).
2. **No reading the source.** A program may not open, read, or be fed its own source file. The text it prints
   has to live inside the program (string literals, data, comments it never reads back).
3. **No output through files.** The text goes straight to stdout. No writing `QR.out` and then `cat`, and no
   cleaning the tool's own stdout with `tail`, `grep` or `tr`.

## Rewritten (same slot, same language)

| Step | Was | Now |
|---|---|---|
| SNOBOL4 | read `QR.sno` back with `INPUT` | one `OUTPUT = '...'` statement per line, and moved from the head to right after Ink (see below) |
| Simula | read `QR.sim` back with `InFile` | `OutText("...")` (2,000-char pieces) / `OutImage`, in 400-statement procedures |
| Oberon | read `QR.obn` back with `Files.Old` | `Out.String` (2,000-char pieces) / `Out.Char(22X)` / `Out.Ln`, in 400-statement procedures, lines kept under 4,000 chars |
| Euphoria | `open("QR.ex","rb")` | `puts(1,"...")` lines (1,000-char pieces) |
| ALGOL 60 | `./QR < QR.alg` (source fed on stdin) | `outstring(1,"...")` (1,000-char pieces that never end in a backslash, since marst's C line-wrapper misreads `\\"`), in 400-statement procedures |
| Boo | `File.ReadAllText("QR.boo")` | one `System.Console.Write('...')` |
| Rocq | shell `printf` prepended an OCaml `Pstring` module | the `.v` file defines its own `Pstring` module, then `ocaml QR_rocq.ml` |
| Logtalk | goal passed with `-g "logtalk_load(...)"` | the program is `settings.lgt`, which Logtalk loads by itself at startup; command is `swilgt -q` |

The Simula, Oberon and ALGOL 60 programs are split into procedures so the C compiler behind each one
never sees one giant function. Piece size matters at the head: with 100-char pieces, cim turned a 54 MB Simula
program into 397 MB of C and gcc passed 8.7 GB of RAM. With 2,000-char pieces, Ruby's output is 15 MB (the old
head was 52 MB) and the head runs Simula 18 s, Oberon 17 s, Euphoria 1 s, ALGOL 60 3 s.

**SNOBOL4 moved.** CSNOBOL4 compiles every statement before running, and it slows down sharply past ~100k
statements (25k: 0.6 s, 100k: 8.4 s, 516k: still compiling after 11 min at 1 GB). It needs no escapes, so it now
sits in the tail, right after Ink: it prints Ink's program and DeadfishTilde prints it.

## Removed (13)

These tools can't put the text on stdout by themselves, so there is no clean way to keep them.

| Step | Why |
|---|---|
| BASIC (bwBASIC) | always prints its banner on stdout |
| BCPL | cintsys writes CR after every LF on the console (hardcoded in `syscintmain.c`) |
| TADS 3 | frob's formatter rewraps and indents text |
| Inform 6 | dfrotz prints a status line first (was cut with `tail`) |
| MetaPost | prints its banner and log lines on stdout |
| Plain TeX | prints its banner on stdout |
| Lout | paginates (form feeds, blank lines; was cleaned with `tr` and `grep`) |
| ACL2 | prints its banner and prompts on stdout |
| Maude | prints result lines and `Bye.` on stdout |
| REDUCE | prints its banner and numbered prompts on stdout |
| FriCAS | prints its banner and prompts on stdout |
| Elm | has no stdout at all (mame: running it through `node -e` crosses the line) |
| Curry | PAKCS runs out of its 1 GB Prolog stack on a 645 KB literal, so the old step read `QR.curry` back. It can come back in a slot where the text is under ~100 KB |

Two neighbors changed to keep the loop valid: Uxntal now packs 120 bytes per line (it feeds Ink directly, Ink
needs fewer than 1,250 lines, and SNOBOL4 after Ink needs lines under 380 chars), and Zoem's source now ends in a newline (it feeds Singular directly).

## Count

284 steps / 273 distinct languages before. **271 steps / 260 distinct languages** after.

## Judgment calls left in

- **F#** writes a project file with `echo` before `dotnet run`. mame's own relay does the same.
- **PureScript** runs through a fixed `run.mjs` that imports the compiled module and calls `main`, the way `spago run` does.
- **Berry** opens `/dev/stdout` to write without a trailing newline. That is stdout, not a file.
- **CUE** uses `cue export --out text -e o`, where `-e o` picks the field to print.

## How to rebuild

`ruby nc/patch.rb` rebuilds `src/code-gen.rb` from `nc/code-gen.rb.orig`. `src/nc-test.rb <Class> [big|nonl|short]`
tests one step with a nasty payload. `nc/lap.sh` runs the full lap inside the `qr284` image.

## Audit 2 (Nov 18, 2026, evening)

Adversarial pass over the 271-step tree against 7 purity rules (no source/disk reads, stdout only, no command-line
code or glue, no stand-ins, payload propagation, standalone programs, honest counts). Commands were read from the
regenerated Makefile, programs from `src/code-gen.rb`, and every step was run alone by the new segment test.

### Found and fixed

| Step | Problem | Fix |
|---|---|---|
| Zoem | **Broke lap v3** (Uiua got an empty file, BQN died). `nc/patch.rb` used a replacement *string* in `sub!`, which halves backslashes, so Zoem lost `\write` and stopped escaping `\`. | block-form `sub!` (all patch.rb edits now use blocks) |
| PureScript | ran through a fixed glue file `/opt/purs/run.mjs` that imports the module and calls `main` | top-level `o = unsafePerformEffect (log """...""")` runs on load; command is `node /opt/purs/out/QR/index.js` |
| CUE | `-e o` put an expression on the command line | the file is a bare emit value `###"..."###`; `cue export --out text QR.cue` (same bytes out) |
| Hush | `std.read(prompt)` prints the text as a prompt and then reads stdin (could hang under an interactive make) | `< /dev/null` (Hush has no print without a newline) |

### S-Lang reads `QR.sed` (critical, rule 1): fixed by dropping the group

**Decision (Nov 18, evening): option b.** `nc/patch.rb` comments out `Scilab_Sed_Shakespeare_SLang`, so the strict
284-clean build is **267 steps / 256 distinct languages**. Scheme now prints Squirrel directly. The 4 can come back if a run order with a cheap slot turns up (option a). The record below
is why the clean template didn't fit.

The old group's encoder also packed backslash runs for every step upstream of it. Without it the head ballooned
(Ruby's output 127 MB, ChucK stalled lap v4 at step 7). So Scheme now holds its text packed in its own string literal
(`:c` colon, `:q` quote, `:0`-`:9` = 2^n backslashes) and unpacks it while printing. No file reads; mame's Ruby step
unpacks its own compressed data the same way. QR.rb sha256 `e96516bb...`.

S-Lang's program does `fopen("QR.sed")` and decodes the payload from sed's `#:` comment lines. That is reading
another step's file. Shakespeare can't carry the payload instead: it speaks one sentence per byte, so the clean
group (mame's own template, `nc/mame-slang-block.rb`, rp-compressed, no reads) is a **32x expander**.

Measured on the real group in `qr284` (`nc/dump/sl.sh`), byte-exact both times:

| payload | Scilab source | play | spl2c | gcc |
|---|---|---|---|---|
| 35 KB | 1.14 MB | 3.4 MB | 78 s | 38 s |
| 100 KB | 3.24 MB | 9.8 MB | 556 s | 112 s |

Slots tried with `nc/move-slang.rb` + `nc/zexp.sh`: before Python / Ksh / BeanShell (tail, 35-48 KB) and before
Perl5 / Parser3 / OCaml (plateau, ~96 KB). Every one ran out of memory (exit 137, one at 18.9 GB) while sizing the
chain: anything downstream of Brain-Flak (30x) / Slashes / Lazy K gets its extra bytes multiplied on the way to the
head. In this order there is no cheap slot. Options are in the audit report (`AUDIT-2.md`).

### Judgment calls kept (mame precedent)

- **sed** runs `sed -E -f QR.sed QR.sed`: sed needs input lines, so it reads its own script. mame's relay does exactly this.
- **dc** `|| true`, **Gzip** `gzip -cd`, the `mv QR.c QR.c.bak` backups, F#/VB `echo` project files, Gleam's `printf` toml,
  Ruby vendor interpreters (`vendor/*.rb`): all as in mame's relay or the same kind of build plumbing.
- **Berry** writes to `/dev/stdout` (that is stdout). **YueScript** `-e` means "run this file".

### New tools

- `nc/dump.rb Name...` writes the exact text a step must print (from the generator, no lap needed).
- `nc/seg.sh [P] [regex]` (in `qr284`) runs every step alone on its expected input, P at a time, and writes
  `nc/seg-result.tsv`. One pass finds every broken step instead of one per lap. `OK-nl` = only an extra final
  newline, which the next language ignores (same as mame's relay).
