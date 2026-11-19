# Quine Relay Records

These are the rules we use to count a quine relay, and the leaderboard for anyone who wants to beat it.
A record needs a public repo and a full run that anyone can repeat. A number alone doesn't count.

## Leaderboard

| Relay | Tier 1 (distinct languages) | Tier 2 (relay steps) | Verified | Date |
|---|---|---|---|---|
| [exacortex/quine-relay-267](https://github.com/exacortex/quine-relay-267) (this repo) | **257** | **267** | `docker build --no-cache` from this repo's `Dockerfile` + `make check` on Ubuntu 26.04, no stand-ins, no-cheating rules ([proof](proof/)) | 2026-11-19 |
| [mame/quine-relay](https://github.com/mame/quine-relay) | 123 | 128 | mame's CI, Ubuntu 26.04 | 2026 |

Withdrawn: [exacortex/quine-relay-284](https://github.com/exacortex/quine-relay-284) (273 / 284, Nov 18, 2026). Some of its steps broke the no-cheating rules below.
Not counted: [exacortex/quine-relay-151](https://github.com/exacortex/quine-relay-151) (143 / 151, Nov 13, 2026). It ran for real, but its BASIC step wrote a file and printed it with `cat` (rule 3).

To add a relay, open a pull request that edits this table and links to your proof (see "How to claim a record" below).

## No-cheating rules

These come from Yusuke Endoh (mame). Every step of a counted relay must follow all three:

1. **No code on the command line.** A command names the program file and sets options. It can't carry program text (`node -e '...'`, a `printf` that adds code).
2. **No reading files.** A program can't open its own source or another step's file. The text it prints lives inside the program.
3. **Output on stdout only.** No writing a file and then `cat`, and no cleaning a tool's output with `tail`, `grep` or `tr`.

Build plumbing is fine when mame's relay does the same thing (an `echo`'d F# project file, `gzip -cd`, `sed -f QR.sed QR.sed`). [NO-CHEAT.md](NO-CHEAT.md) lists the cases we kept and why.

## Tier 1: distinct languages

Each language counts once. A language counts only if it has its own name and its own grammar or spec.

- Implementations of the same language count once. (Guile, Chez, and Chicken are all Scheme, so they count once.)
- Versions of a language count once. (FORTRAN77 and Fortran90 are both Fortran.) Raku is the one exception: it was renamed from Perl 6 in 2019 and is its own language now.
- Encodings and word swaps of another language don't count. (Ook! is Brainfuck. JSFuck is JavaScript. WebAssembly binary and text are one language.)
- File formats that aren't programs don't count. (Gzip.)
- Different CPU/VM instruction sets *do* count separately when each has its own ISA and assembler/runtime (x86-64 NASM, ARM64, RISC-V, 6502, Z80, MMIX, Uxntal, Parrot PASM, LLVM IR, JVM Jasmin, .NET MSIL).
- A language with its own name that compiles to another one *does* count. (TypeScript, CoffeeScript, Genie, Hy, Coconut, Racket, PureScript, Gleam, MoonScript, Teal, YueScript.)

[LANGUAGES.md](LANGUAGES.md) shows how each of our 267 steps is counted, with the reason for all 10 merges (`267 - 10 = 257` distinct Tier 1 languages).

## Tier 2: relay steps

Steps are counted the way mame counts them, plus a limited number of extra implementations. mame's 128 historical steps are grandfathered as-is; every step added beyond them must:

1. Run on its **own interpreter or compiler**: a different program, not the same one with a different flag.
2. Have **its own source text**. Two steps can't run the same program.
3. Be **verified for real** (see below).
4. Stay within the **family cap**: at most 3 steps per language, counting the first one.

Not allowed for new steps: version-only copies (Python 3.12 and 3.13), the same binary twice, and steps that only pass the text along (`cat`, `base64`, a plain `echo`).

## How to claim a record

A claim needs all of these:

1. **A public repo** with the seed program, a `Dockerfile` that installs every language, and a list of steps tagged `T1` or `T2 only` (like [LANGUAGES.md](LANGUAGES.md)).
2. **A full run in Docker** built from that `Dockerfile` with zero stand-ins. Every step runs on its real interpreter or compiler, in order, in one image.
3. **Every step follows the no-cheating rules** above.
4. **A closed loop.** The last step's output must be byte-for-byte identical to the seed. Publish the SHA-256 of both files.
5. **The logs** of the build and the run, committed to the repo.
6. **Credit** to Yusuke Endoh's Quine Relay if you build on it, with its MIT license kept as-is.

Anyone should be able to repeat the run with `docker build` and `docker run`. If they can't, the claim doesn't stand.

## Side records

| Record | mame's 128 | This repo (267) |
|---|---|---|
| Distinct languages (Tier 1) | 123 | **257** |
| Relay steps (Tier 2) | 128 | **267** |
| Seed size per step | **106.8 B** (13,664 ÷ 128) | 130.7 B (34,888 ÷ 267) |
| Retired mame languages restored | — | **16 of 20** |
