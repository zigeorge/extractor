# extractor

This repository now contains a starter implementation plan and Flutter scaffold for a personal expense tracker Android app.

## Added
- Product requirements and milestones: `docs/product_spec.md`
- UX flow and interaction outline: `docs/ux_flow.md`
- Flutter starter app scaffold: `flutter_expense_tracker/`

## Run (when Flutter SDK is installed)
```bash
cd flutter_expense_tracker
flutter pub get
flutter run
```

## Current status
The app scaffold includes:
- Onboarding screen (sheet URL + initial balance)
- Home screen with balance summary, search, basic type filters, add/delete transactions
- Add transaction form with amount/type/comment/person/date-time fields
- In-memory repository abstraction ready to be replaced with Google Sheets integration
