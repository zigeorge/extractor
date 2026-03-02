# Personal Expense Tracker (Flutter Android) — Product Spec v1

## Goal
Build an Android app in Flutter for tracking credit/debit transactions with Google Sheets as the shared online data source.

## Confirmed Scope
- Single-user workflow (shared behavior possible when multiple devices use the same public sheet URL).
- Always-online mode.
- Public Google Sheet link configuration on onboarding.
- Initial balance setup on onboarding.

## Core Features
1. Date-grouped transaction list.
2. Filters:
   - Type (credit/debit)
   - Single date or date range
   - Search by comment
3. Add transaction page from `+` action.
4. Transaction form fields:
   - Required: amount, type
   - Optional: comment, person name
   - Date/time picker defaults to current local datetime
5. Save action updates list immediately.
6. Optional summary cards:
   - Current balance
   - Debt (money user owes)
   - Credit (money lent by user)

## Data Model
Mandatory:
- `id` (UUID)
- `amount` (decimal, precision 2)
- `type` (`credit` / `debit`)
- `created_at` (local datetime)
- `updated_at` (local datetime)

Optional:
- `comment`
- `person_name`

## Business Rules
- `current_balance = initial_balance + total_credit - total_debit`
- Debt/Credit summary is derived from transaction type and person context.

## Google Sheet Schema
Header row:

`id | amount | type | created_at | updated_at | comment | person_name`

## Non-Goals for v1
- Offline write queue
- Authentication hardening
- Undo delete
- Encryption or app lock

## Milestones
- M1: App scaffold + onboarding + transaction list
- M2: Add transaction flow + local state updates
- M3: Google Sheet read/write integration + filters/search
- M4: Summary cards + delete flow + polish
