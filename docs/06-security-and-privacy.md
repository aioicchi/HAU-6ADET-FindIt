# Security and privacy

This repository is public. Fill this in honestly and date it; it is checked as
part of grading.

**Last checked:** 2026-10-10

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Sample lost-and-found items | In the app's sample data or assets | Anyone who accesses the public demo |
| Item names, descriptions, locations, and status labels | Sample data or current app state | Anyone who can view the corresponding listings |
| Search keywords and filter selections | Current app state in the browser | The person using the app |
| Information entered in report forms | Temporary app state, depending on implementation | The person using the app while the data is displayed |
| Selected item photos | Sample assets or temporary browser/app state, depending on implementation | Anyone who can view the image if it is displayed in the public demo |

The current demo does not intentionally save reports to a database or permanently store submitted item information. Temporary changes may be lost when the page is refreshed or the application is restarted.

## Secrets

- Values my app needs at run time: None are intended for the current demo. The app uses sample or temporary data and does not require backend credentials for its planned functionality.
- Where they live locally: No .env file is required if the app does not use environment variables. If environment variables are added, .env must be git-ignored, and .env.example should contain placeholder values only.
- Where the deploy workflow gets them: No deployment secrets are expected to be required for the current demo. If credentials become necessary for a future deployment, they should be stored in repository secrets under Settings > Secrets and variables > Actions.
- Anything my deployed web build carries that a visitor could read, and why that
  is acceptable: The web build contains the Flutter application code, public assets, and sample data. These are necessary for the demo to run and are not considered private. No private API keys, passwords, or privileged backend credentials should be included in the deployed build.

## What protects the data on the service side

The current FindIt demo does not intentionally send submitted reports to a backend service or database. 
It uses sample or temporary data to demonstrate browsing, reporting, viewing item details, and managing reported items.

Since the current version does not use a backend database, Supabase Row Level Security (RLS) policies and Firebase security rules are not applicable. 
There are no server-side data access policies to configure for the current demo.

If a backend is introduced in the future, authentication, access controls, and database security policies
must be implemented and tested before real user information is stored.

## Checklist

- [ ] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed
- [ ] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [ ] No service account file, keystore or `service_role` key anywhere in the repo
- [ ] Security rules or RLS policies written and tested, not left open
- [ ] No real personal data in sample data, screenshots or the video
- [ ] No course or university credentials anywhere
- [x] Anyone whose data appears in a test was asked first

If you found and revoked a key while doing this, say so here. Catching it is the
right outcome, not an embarrassment.
