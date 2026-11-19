# Purity audit 2 (Nov 18, 2026)

*Written against the working tree. Paths under `nc/` and `src/code-gen.rb` line numbers refer to the audit workspace; the `nc/` scripts are not part of this repo. The fixes live in `src/code-gen.rb`. This tree is the result: 267 steps after the S-Lang group was dropped.*

Tree: `quine-relay-256\milestones\284-clean` (271 steps / 234 generator classes, after the first no-cheat pass).
Read from: the regenerated Makefile (all 397 recipe lines), `src/code-gen.rb` (every active class), and a run of
every step alone on its exact expected input (`nc/seg.sh`, results in `nc/seg-result.tsv`).

## 1. Violations

### Critical

| # | Step | Where | Snippet | Rule | Status |
|---|---|---|---|---|---|
| C1 | Zoem (run 87) | `nc/patch.rb` Zoem line -> `src/code-gen.rb:2821` | `Code = %q("\\write{-}...Q[PREV,/[\\{}]/]...")` | 5 (payload broke) | **Fixed.** `sub!` with a replacement string halved the backslashes: no `\write`, `\` unescaped. This is what killed lap v3 at Uiua -> BQN. |
| C2 | S-Lang (run 61) | `src/code-gen.rb:3183` | `variable f=fopen("QR.sed","r") ... fgets(&s,f)` | 1 (reads another step's file) | **Fixed by removal (P1b, user's call, Nov 18 evening).** Scilab, sed, Shakespeare and S-Lang are commented out by `nc/patch.rb`; Scheme now feeds Squirrel and unpacks backslash runs from its own literal. 267 steps, QR.rb 34,888 B (sha256 `e96516bb...`). **Lap v5 PASSED Nov 18, 11:41 pm: QR2.rb == QR.rb, 24.4 min.** |

### Borderline

| # | Step | Where | Snippet | Rule | Status |
|---|---|---|---|---|---|
| B1 | PureScript | `code-gen.rb:1609` | `node /opt/purs/run.mjs` (glue file: `import {main}...; main()`) | 3 | **Fixed:** `o = unsafePerformEffect (log ...)`, `node /opt/purs/out/QR/index.js` |
| B2 | CUE | `code-gen.rb:3316` | `cue export --out text -e o` | 3 | **Fixed:** bare emit value, no `-e` (same bytes out) |
| B3 | Hush | `code-gen.rb:3427` | `std.read(prompt)` reads stdin after printing | 1 | **Fixed:** `< /dev/null` |
| B4 | sed (run 59) | Makefile | `sed -E -f QR.sed QR.sed` | 1 | Kept: mame's relay does exactly this (sed needs input lines) |
| B5 | Promela | Makefile | `spin -T` adds `1 process created` to stdout | 2 | Kept: mame's own design, the `#` comments it out downstream |
| B6 | F#, VB, Gleam | Makefile | `echo '<Project...>'`, `printf 'name = "qr"...'` | 3 | Kept: build config, not program code (mame does F#/VB the same way) |
| B7 | dc | Makefile | `dc QR.dc > QR.dhall \|\| true` | - | Kept: mame's line |
| B8 | 6502 / Z80 | `vendor/run6502.py`, `runz80.py` | self-written CPU runners | 4/6 | Kept: cross-checked byte-for-byte on py65 and z80 (`audit/scripts/verify_6502_z80.py`); re-run on the clean build |
| B9 | Berry | `code-gen.rb:2399` | `open("/dev/stdout","w")` | 2 | Kept: that is stdout |

No other file opens, `$0`/`__FILE__`/argv/env reads, `-e`/`-c` code, `cat`/`tail`/`tr` cleanup or sidecar outputs.
The `::File.read(...dat)` calls run in the generator (as in mame's), not in any step.

## 2. Clean verification summary

- **Segment test:** 233 of 234 classes finished. 180 byte-exact, 45 exact apart from one final newline (which the
  next language ignores, as in mame's relay), F# off by its known trailing space, Promela by spin's commented-out
  trailer (B5). 5 were harness errors (`!` prefix, `wasmtime` missing, Makefile `.bak` files), now fixed in
  `nc/seg.rb`. Jasmin was still assembling at 13 min / 7 GB when this was written (it ran fine in the 284 lap on a
  452 KB file; lap v4 will show it). Ruby's real output (15.8 MB) is not byte-equal to the generator's unrolled
  model (17.3 MB, differs inside S-Lang's `#:` payload); the next steps pass on both, and this goes away with C2.
- **Rules 1-4 and 6:** 270 of 271 steps pass with no exceptions apart from B4-B9. **S-Lang (C2) fails.**
- **Rule 5 (canary) and the full loop:** need lap v4 (queued: `LAP 284-clean no-cheat 271 v4`). Not claimed yet.
- **Rule 7:** mame's relay is dated 2013 everywhere (README copyright, VICTORY-LAP). RECORDS.md keeps two counts:
  Tier 2 relay steps (mame's way: F77/F90, JSFuck, Gzip, Ook! each count) and Tier 1 distinct languages. The 284
  numbers in github-repo still need updating to 271 / 260 (or 267 / 256 under P1b).

## 3. Remediation plan

- **P1 S-Lang (C2), pick one:**
  - **a. Reorder (keeps all 4):** mame's no-read template (`nc/mame-slang-block.rb`) is byte-exact (35 KB and
    100 KB tested) but blows its payload up 32x. Every slot tried ran out of memory while sizing the chain (Brain-Flak /
    Slashes / Lazy K upstream multiply the extra bytes). Needs the 256-order search to find an order where the group
    sits in a tiny zone with nothing big upstream. Days, not hours.
  - **b. Drop Scilab + sed + Shakespeare + S-Lang from strict builds:** 267 steps / **256 distinct languages**. Loses
    4 of mame's own languages.
  - **c. Drop S-Lang only:** Shakespeare can't carry the payload, so this falls back to b.
- **Strict builds (`256-alpha`, `256-opt`, `128-atsp-opt`):** port C1's lesson (block-form `sub!`) and B1-B3; S-Lang
  reads `QR.sed` in 128-alpha-opt, 128-atsp-opt and 256-opt too (log entry e1118162604447), so P1 applies there.
- **Every fix:** `ruby nc/patch.rb` rebuilds `src/code-gen.rb`; `bash /w/nc/seg.sh 4` in `qr284` re-checks all steps.
