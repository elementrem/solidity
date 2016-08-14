### 0.3.6

Features:

 * Formal verification: Take external effects on a contract into account.
 * Type Checker: Warning about unused return value of low-level calls and send.
 * Output: Source location and node id as part of AST output
 * Output: Source location mappings for bytecode
 * Output: Formal verification as part of json compiler output.

Bugfixes:

 * Commandline Interface: Do not crash if input is taken from stdin.
 * Scanner: Correctly support unicode escape codes in strings.
 * JSON output: Fix error about relative / absolute source file names.
 * JSON output: Fix error about invalid utf8 strings.
 * Code Generator: Dynamic allocation of empty array caused infinite loop.
 * Code Generator: Correctly calculate gas requirements for memcpy precompile.
 * Optimizer: Clear known state if two code paths are joined.
