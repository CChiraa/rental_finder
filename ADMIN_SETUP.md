# YuppiesLah Admin Module — Setup

## 1. Where the files go

Drop these into your project, keeping the same folder paths:

```
lib/services/report_service.dart                  (new)
lib/screens/admin/admin_home_screen.dart          (new)
lib/screens/admin/admin_dashboard_tab.dart        (new)
lib/screens/admin/admin_users_tab.dart            (new)
lib/screens/admin/admin_reports_tab.dart          (new)
lib/screens/admin/admin_settings_screen.dart      (new)
lib/screens/tenant/p_report_issue_screen.dart     (REPLACES your existing one)
```

The replaced report screen keeps your exact layout — it now also saves each
report to the Firestore `reports` collection so the admin can receive them.

## 2. Route admins to the dashboard on login

In `lib/screens/signin.dart`, add the import at the top:

```dart
import 'package:smart_rental_app/screens/admin/admin_home_screen.dart';
```

Then in `_signInUser()`, the role check currently handles `'Tenant'` and
`'Landlord'`. Add an `'Admin'` branch **before** the others:

```dart
if (activeRole == 'Admin') {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          AdminHomeScreen(userName: name, userEmail: userEmail),
    ),
  );
} else if (activeRole == 'Tenant') {
  // ... your existing code ...
}
```

(Optional) Do the same inside `_signInWithGoogle()` if you want Google admins.

## 3. Make a user an admin

The admin is just a normal `users` document whose `roles` array contains
`'Admin'` and whose `activeRole` is `'Admin'`. In the Firebase console, open
`users/{uid}` and set:

```
roles:      ["Admin"]
activeRole: "Admin"
```

That account will now land on the admin dashboard after signing in. Pure-admin
accounts are automatically hidden from the user list and the user counts.

## 4. Firestore security rules

Add a rule so any signed-in user can create a report, but only admins can read
or modify them. Example:

```
match /reports/{reportId} {
  allow create: if request.auth != null;
  allow read, update, delete: if request.auth != null
    && 'Admin' in get(/databases/$(database)/documents/users/$(request.auth.uid)).data.roles;
}
```

## What you get

- **Dashboard** — live counts of total users, tenants, landlords, pending
  reports, plus a Pending / Reviewed / Resolved summary.
- **View Users** — searchable list with All / Tenant / Landlord filter chips.
- **Reports** — every tenant report, newest first; tap to read full details,
  change status, or delete.
- **Settings** — dark-mode toggle (uses your global theme), admin profile,
  and logout.

Everything reads live from Firestore and matches your gold/amber theme,
glass cards, Inter + Cormorant Garamond fonts, and dark-mode support.
