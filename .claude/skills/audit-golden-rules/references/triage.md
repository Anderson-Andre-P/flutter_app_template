# audit-golden-rules — triaging a finding

Decide for each finding, in this order:

1. **False positive?** The line is not a violation of the rule (a divisor that is not spacing, a log tag, a test-only string). Fix the script, not the code: add the case to `assets/fixtures/lookalike/`, watch the test fail, adjust the pattern. If it is a one-off, use an `allow` entry with `contains` and a reason.
2. **Trivial and safe to fix inside the current task?** Fix it in the same change (move the string to the constants, use the token). Keep it in its own commit when it touches a file the task did not need.
3. **Real but outside the current task?** Record it in the project's gaps log (what, where, impact, decision), then baseline it:
   - one-off line: `allow` entry with `contains` and `reason`;
   - many occurrences in a file: `--suggest-allow --reason "<gap id>: why"`, which writes a `maxCount` ratchet.
4. **Never** baseline without a recorded owner for the debt, and never raise a `maxCount` to absorb a new violation: the file got a new literal, so fix that literal.

## Paying debt down

When a file with a `maxCount` entry is edited and a literal is converted, lower its `maxCount` (or delete the entry) in the same commit. Re-run `--suggest-allow` for a rule to see the current counts; a count lower than the entry's is a sign the entry can shrink.

## Reading the output

`path:line: rule — hint`. Group by rule first (`--summary`), then by file; a rule with hundreds of findings in many files is a policy question for the owner, not something to fix in one pass.
