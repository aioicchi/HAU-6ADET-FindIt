# Proposal

FindIt, a university lost-and-found application.

## The problem, in one sentence
Students who lose or find belongings on campus may have difficulty connecting with the owners
because there is no single place to report, browse, and check lost-and-found items.

## Who it is for
- University students who have lost personal belongings around campus and want an easier way to find them.
- Students and staff who find misplaced items and want to report them so the owners can identify and claim them.
- Campus community members who need a simple way to view reported items and check their details.

## Core features
- Browse lost and found items: View reported items with photos, names, locations, dates, and LOST or FOUND status labels.
- Report an item: Fill out a form with the item's name, description, status, location, photo, and contact information.
- Item details: Open an item to view its photo, description, location, date reported, and other available information.
- My Reported Items: View your reported items and separate active reports from resolved ones.
- Manage reports: View, edit, or mark reported items as resolved.
- Search and filter: Find items more easily by searching for keywords and filtering the available listings.
- Simple navigation: Switch between Browse, Report, and My Items through the bottom navigation bar.

## Out of scope, and why
- A mobile app for Android or iOS. The current version is a Flutter web demo, so development is focused on making the application work in a browser.
- A database and permanent data storage. The demo uses sample or temporary data to demonstrate the interface and basic interactions. Reports are not permanently saved.
- User accounts and authentication. These are not included in the current demo because the main focus is demonstrating the lost-and-found workflow.
- Real-time notifications. The demo does not have a backend service to notify users when a matching item is reported or when a report changes.
- Automated item matching. The current version focuses on browsing and filtering items rather than automatically identifying possible matches.
- Actual item claiming and verification. Contact information may be displayed in the demo, but there is no complete system for verifying ownership or processing claims.

## Data the app remembers, and where it is saved
| Data | Where it is saved |
| --- | --- |
| Item names and descriptions | Sample or temporary app data |
| LOST or FOUND status | Sample or temporary app data |
| Item locations and dates reported | Sample or temporary app data |
| Item photos | Sample assets or temporary image selections |
| Contact information | Sample or temporary form input |
| Active and resolved reports | Demo data and temporary app state |
| Search keywords and filter selections | Current app state |
| Changes made through forms | Temporary state; not permanently saved |

The current version is intended for demonstration purposes. Data entered or changed during use is not guaranteed to persist
after the page is refreshed or the app is restarted.

## Risks
- Data may disappear. Reports and changes are not permanently stored. Mitigation: use sample data for the demo and explain this limitation during presentation.
Item information may be incomplete or inaccurate. Sample listings do not represent verified real-world reports. Mitigation: display clear item details and status labels.
- Photos may not be available. Some listings may use placeholder or sample images. Mitigation: provide sample images and a clear photo upload interface.
- Search results may be limited. Search and filters can only work with the data available in the demo. Mitigation: test them using a variety of sample items.
- The interface may not fit every screen size. Different browser sizes can affect the layout. Mitigation: test the web demo at different viewport sizes and adjust the Flutter widgets as needed.
- Users may assume reports are real. The interface resembles a functional lost-and-found system even though it is a demo. Mitigation: clarify that the current version uses sample or temporary data.

## Changes since the last version
- 2026-09-20 to 09-26: Started setting up the Flutter project and organizing the initial application structure based on the completed mockups.
- 2026-09-27 to 10-03: Began implementing the main screens, including Browse Items and the Report Item form, using Flutter widgets.
- 2026-10-04 to 10-09: Continued developing the Browse Items, Item Details, Report Item, and My Reported Items screens, identifying the widgets and interactions needed for the MVP.
- 2026-10-09: Confirmed that the current deliverable is a web-based demo using sample or temporary data, with database integration and permanent storage outside the current scope.
