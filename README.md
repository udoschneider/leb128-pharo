# LEB128 for Pharo

LEB128 ("Little Endian Base 128") is a variable-length integer encoding that stores an integer as a sequence of 7-bit groups, each byte's high bit signalling whether more bytes follow. It is used by DWARF debug data and WebAssembly, in both an unsigned and a signed (two's-complement, sign-extended) variant.

This package implements both variants for Pharo as extension methods on `Integer`, `ByteArray` and `PositionableStream`. Because Pharo integers are arbitrary precision, there is no fixed width limit — values are encoded in as many bytes as they need.

## Installation

There is no `BaselineOf` or `ConfigurationOf` in this repository, so there is no Metacello install snippet. Load it manually with Iceberg:

1. Iceberg → Add repository → Clone from github.com → `udoschneider/leb128-pharo`, branch `master`.
2. Set the source directory to `src` (this is what `.project` declares; Iceberg reads it automatically).
3. Right-click the repository → Load the packages `LEB128-Core` and, optionally, `LEB128-Tests`.

## Usage

### Encoding an Integer to a ByteArray

```smalltalk
624485 asUnsignedLeb128.   "=> #[16rE5 16r8E 16r26]"
-123456 asSignedLeb128.    "=> #[16rC0 16rBB 16r78]"
```

### Decoding a ByteArray to an Integer

```smalltalk
#[16rE5 16r8E 16r26] unsignedLeb128Integer.  "=> 624485"
#[16rC0 16rBB 16r78] signedLeb128Integer.    "=> -123456"

"Decode starting at a 1-based index; trailing bytes are ignored."
#[16r26 16rE5 16r8E 16r26] unsignedLeb128IntegerAt: 2.  "=> 624485"
#[16r78 16rC0 16rBB 16r78] signedLeb128IntegerAt: 2.    "=> -123456"
```

### Writing into an existing ByteArray

These write in place via `replaceFrom:to:with:` and return the receiver, so the receiver must be mutable (copy literals) and large enough to hold the encoding.

```smalltalk
#[0 0 0] copy unsignedLeb128IntegerPut: 624485.        "=> #[16rE5 16r8E 16r26]"
#[0 0 0 0] copy unsignedLeb128IntegerAt: 2 put: 624485. "=> #[0 16rE5 16r8E 16r26]"
#[0 0 0] copy signedLeb128IntegerPut: -123456.         "=> #[16rC0 16rBB 16r78]"
#[0 0 0 0] copy signedLeb128IntegerAt: 2 put: -123456.  "=> #[0 16rC0 16rBB 16r78]"
```

### Streams

The stream methods are the primitives everything else is built on; they are defined on `PositionableStream`, so they work on any read/write stream over a byte collection and can be mixed freely with other stream reads and writes.

```smalltalk
ByteArray streamContents: [ :out |
    out nextUnsignedLeb128IntegerPut: 624485.
    out nextSignedLeb128IntegerPut: -123456 ].

| in |
in := #[16rE5 16r8E 16r26 16rC0 16rBB 16r78] readStream.
in nextUnsignedLeb128Integer.  "=> 624485"
in nextSignedLeb128Integer.    "=> -123456"
```

## API

| Receiver | Selector |
| --- | --- |
| `Integer` | `asUnsignedLeb128`, `asSignedLeb128` |
| `ByteArray` | `unsignedLeb128Integer`, `unsignedLeb128IntegerAt:`, `unsignedLeb128IntegerPut:`, `unsignedLeb128IntegerAt:put:` |
| `ByteArray` | `signedLeb128Integer`, `signedLeb128IntegerAt:`, `signedLeb128IntegerPut:`, `signedLeb128IntegerAt:put:` |
| `PositionableStream` | `nextUnsignedLeb128Integer`, `nextUnsignedLeb128IntegerPut:` |
| `PositionableStream` | `nextSignedLeb128Integer`, `nextSignedLeb128IntegerPut:` |

## Packages, requirements and dependencies

- `LEB128-Core` — the implementation, four files, roughly 130 lines. No dependencies beyond the base Pharo image.
- `LEB128-Tests` — `LEB128Tests`, an SUnit `TestCase` with 8 test methods. Its 1813 lines are almost entirely generated test data: two literal arrays of 1024 integer/byte-array pairs each, which account for about 1690 of those lines. The class-side methods `signedLeb128IntegerData` / `unsignedLeb128IntegerData` regenerate those literals by fetching reference vectors from the `mohanson/leb128` project over HTTP using `ZnEasy`; they are not run by the tests themselves.

No minimum Pharo version is declared anywhere in the repository. The Tonel source format, the method formatting and the last commit date (July 2021) point to the Pharo 8/9 era; the code uses only long-standing base-image API and has not been verified against newer releases.

## Status and license

Small, single-purpose and unmaintained: two commits, last touched in July 2021. Encode and decode round-trip against 2048 reference vectors for both variants. The unsigned encoder is only defined for non-negative integers — passing a negative value does not terminate. Note also that the two test-data accessors have their names inverted (`signedLeb128IntegerData` holds the unsigned vectors and vice versa); the tests compensate by calling them crosswise, so results are correct, but the names are misleading.

There is no LICENSE file in this repository and no license is stated in the source.
