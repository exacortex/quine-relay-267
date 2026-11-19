# Quine Relay — 267 steps / 257 distinct languages

A fork of Yusuke Endoh's (mame) [Quine Relay](https://github.com/mame/quine-relay), scaled from 128 steps (123 distinct languages) to **267 steps (257 distinct languages)** under mame's no-cheating rules, and verified from a clean Ubuntu 26.04 `Dockerfile` build on November 19, 2026.

## Why you can't just splice languages in

In a quine relay, every step carries the whole rest of the loop as data. A step that grows its payload by a constant factor (byte arrays, hex escapes, doubled quotes and backslashes) multiplies the input of every step before it. mame's relay already has two backslash-doubling ladders, and when we first merged our 21 language batches onto it, the intermediate files passed 250 MB. Compilers crashed, 64 KB JVM constant pools overflowed, 8-bit CPU ROMs ran out of room, and V8 hit its AST limit.

## What made 267 steps fit

### 1. Forth with no backslashes, Fortran 90 in subroutines
mame's Forth step used `S\" ...\"`, which escapes every `\` and `"` and feeds straight into C++, C, Bash, Ada and the upper ladder. A tilde-delimited `126 PARSE ...~` string has no backslashes at all and stays inside FORTRAN 77's 72 columns. Splitting Fortran 90 into 500-call subroutines did the rest. Together they shrank the Common Lisp to Clojure stretch about 45x and C++ about 73x in the first merge.

### 2. LZ78 in Kotlin, and TXR moved next to it
JSFuck turns JavaScript into `[][(![]+[])...]` nodes, and a 3 MB input blew past V8's memory. Kotlin now carries a 3-digit base-78 LZ78 dictionary (474,552 codewords from the 84 printable characters `42..125`), and TXR sits right after it. That brought the input JSFuck has to encode down to a size V8 handles in seconds.

### 3. The head: old languages that carry their text as literals
Right after Ruby comes a run of classic compilers: Simula, Oberon, Euphoria and ALGOL 60. In the withdrawn 284 build these steps read their own source files. Here each one prints string literals (1,000- to 2,000-character pieces), grouped into 400-statement procedures so the C compiler behind each one never sees one giant function. SNOBOL4 compiles every statement before it runs, so it moved from the head to the tail, after Ink.

### 4. Scheme packs the backslashes
Escaping layers turn the text into long runs of backslashes. Scheme (the step before Squirrel) holds its text packed in its own string literal: `:c` for a colon, `:q` for a quote, and `:0`-`:9` for runs of 1 to 512 backslashes. It unpacks while printing. Without it, Ruby's output grows from about 16 MB to 127 MB and the head stalls. In the 284 build, the Scilab -> sed -> Shakespeare -> S-Lang group did this job, but S-Lang read sed's file to do it, so that group is gone (see [NO-CHEAT.md](NO-CHEAT.md)).

### 5. Re-Pair compression across six assembly languages
Literal assemblers (`BYTE "..."` plus `.byte N` for each quote and newline) grow the source 3-5x per step and overflow the 64 KB address space of the 6502 and Z80. Pair-compressing assemblers alternate with literal ones (Uxntal -> MMIX -> 6502 -> ARM64 -> Z80 -> RISC-V), and the BeanShell -> Befunge -> BLC8 -> Brainfuck -> ksh -> Lazy K -> LiveScript group sits right after RISC-V, where the text is small.

### 6. Real interpreters for the esolangs, and a family cap
Hexagony, Rail, Kipple, Taxi and Rockstar run on their canonical upstream interpreters. Glass and Emmental were checked byte-for-byte against the reference implementations. The 6502 and Z80 steps run on CPU emulators bundled in `vendor/`, checked byte-for-byte against `py65` and `z80`. No language family has more than 3 steps (Scheme: Guile, Chicken, Chez).

### 7. Working around fixed limits
- **JVM 64 KB limits:** chunked literals and methods in Java, Groovy, Clojure, Jasmin, AspectJ, ArnoldC, Fantom, Golo, Ballerina, Yeti, Gosu and Frege.
- **WebAssembly:** data-segment sizes use 4-byte LEB128, so segments can hold up to 256 MB.
- **Heaps and buffers:** a 50 MB LZ77 buffer in C, a larger `RDSTACK_SIZE` for Lazy K, `a68g --heap 512M` for ALGOL 68, chunked literals in Rocq, `${file ...}` in the Makefile step (past `MAX_ARG_STRLEN`), and 200-statement subroutines in Ratfor.

## The languages this fork added

| Theme | Languages |
|---|---|
| **Base 151 & 157** | ChucK, dash, groff, Hy, Jsonnet, newLISP, NQP, PicoLisp, Racket, SQL (SQLite), xonsh, mksh, BusyBox ash, yash, Elvish, VHDL, Genie, XQuery, Koto, Macaulay2, Coconut, Anko, Tengo, Rhai, rep (librep), Chez Scheme, Chicken Scheme |
| **mame retirees + Seed7** | Maxima, GNU Smalltalk, UCBLogo, Gri, Julia, Dafny, A+, Boo, CDuce, Falcon, eC, Lisaac, nesC, Parrot asm (PASM), GSL, AspectC++ *(16 restored)*, Seed7 *(new)* |
| **JVM & JS targets** | Fantom, Frege, Golo, Gosu, Ballerina, Yeti, ReScript, PureScript, Imba, Pyret, Wisp |
| **Modern shells** | PowerShell, Nushell, Ion, YSH (Oils), Murex, Hush, es |
| **Modern systems** | Zig, Odin, V, Hare, C3, Nelua, Pony, Chapel, Inko, Koka, Roc, Gleam |
| **Proof, logic & rules** | Agda, Idris 2, Lean 4, Rocq, F*, CLIPS, Picat, Mercury, Logtalk, Dart |
| **Array & math** | J, K (ngn/k), BQN, Uiua, Nial, Klong, Singular, Frink, Mathics, Numbat |
| **Scripting** | Janet, Io, Wren, Berry, Gravity, Umka, MoonScript, Teal, YueScript, Arturo, Ring, TXR |
| **Historical & paradigms** | SNOBOL4, Simula, Oberon, Euphoria, ALGOL 60, Pyth, Emmental, ArnoldC, LFE, Joy, Factor |
| **Interactive fiction** | Ink |
| **Assembly & tiny VMs** | Uxntal, MMIX, 6502 asm, ARM64 asm, Z80 asm, RISC-V asm |
| **Esolangs & config** | ><> (Fish), Hexagony, ///, CJam, Underload, Brain-Flak, Rail, Kipple, Beatnik, Glass, Taxi, Deadfish~, Rockstar, Nix, Pkl, CUE, Nickel, Starlark, Rego |

Removed under the no-cheating rules (they can't put clean text on stdout): BASIC (bwBASIC), BCPL, TADS 3, Inform 6, MetaPost, Plain TeX, Lout, ACL2, Maude, REDUCE, FriCAS, Elm, Curry. [LANGUAGES.md](LANGUAGES.md) has the full run order.

## Credits & License

Original Quine Relay design, uroboros generator, and MIT license: **Yusuke Endoh (@mametter)** and contributors.
267-language extension, corridor work and verification: **Drawn With Code (@exacortex / @rasteia)**, MIT license.