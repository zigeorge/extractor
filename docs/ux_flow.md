# UX Flow — Expense Tracker v1

## 1) Onboarding
1. Welcome screen with short explanation.
2. Input: Public Google Sheet URL.
3. Validate URL and show test status.
4. Input: Initial balance.
5. Continue to Home.

## 2) Home Screen
- App bar: title + filter icon.
- Top cards:
  - Current Balance
  - Debt
  - Credit
- Search field (comment search).
- Filter chips:
  - All / Credit / Debit
  - Date presets (Today, 7 Days, 30 Days, Custom)
- Date-grouped transaction list.
- Floating Action Button (`+`) for Add Transaction.

## 3) Add Transaction Screen
- Amount text field (required; decimal keyboard).
- Type segmented toggle (credit/debit).
- Optional fields:
  - Comment
  - Person name
- Date & time picker (default now, local timezone).
- Submit button.

## 4) Delete Flow
- Swipe item to reveal delete.
- Confirm delete dialog.
- Remove from source and refresh list.

## 5) Empty/Error States
- Empty list: CTA “Add your first transaction”.
- Network/sheet errors: in-line message + Retry action.
