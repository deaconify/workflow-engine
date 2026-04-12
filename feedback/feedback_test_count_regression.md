---
name: Test count regression check
description: Record baseline test count before implementation and verify exact match after — agents must not delete tests
type: feedback
originSessionId: 4fe53ee3-15a4-462b-be98-d9f7db785972
---
Record the baseline test count BEFORE implementation starts and verify the EXACT same count after all changes.

**Why:** In Issue #604, migration agents deleted 57 tests (registration tests, audit failure tests, correlationId tests, webhook CRUD tests) instead of migrating them. This wasn't caught until the reviewer pointed out the count dropped from 4777 to 4720.

**How to apply:**
1. At Step 3 start: record `npm test 2>&1 | grep "Tests"` count as baseline
2. In every agent prompt for test migration: include "DO NOT delete any tests. Test count MUST remain at [baseline]. If you can't migrate a test, skip it and report — never delete."
3. At Step 4 (review): verify test count matches baseline exactly
4. If count drops, investigate which tests were removed and restore them
