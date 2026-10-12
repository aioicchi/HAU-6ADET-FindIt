# AI usage

This project was built with AI assistance. This file is the record of it.

## 1. How I used AI

At least six entries. One per real use. Every entry needs a commit link.

### 2026-10-11 - Screen Documentation

- **Tool:** ChatGPT (Open AI)
- **What I asked for:** Short descriptions of each FindIt screen, including what it displays, what the user can do, and where each action leads.
- **What it gave back:** Descriptions for the Opening, Browse, Report Item, My Reported Items, Item Details, Notifications, and Profile screens.
- **What I kept, what I changed, and why:** I used the descriptions as a starting point for documenting the app's navigation and screen functionality. I provided screenshots of the actual interface so the descriptions would better match the project.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/ff6f97232a73667d4d82ac81cdbc1b4639018113

### 2026-10-11 - Fixing Image Embedding on GitHub

- **Tool:** ChatGPT (Open AI)
- **What I asked for:** Help fixing images that were not appearing in my GitHub Markdown file.
- **What it gave back:** An explanation of relative image paths, folder structures, and how to use HTML image tags to control image width.
- **What I kept, what I changed, and why:** I used the explanation to check my image paths and understand how they depend on the location of the Markdown file. I still needed to verify that the filenames and folder paths matched the actual repository.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/ff6f97232a73667d4d82ac81cdbc1b4639018113

### 2026-10-05 - Automatic matching, simulated chat replies and claim location

- **Tool:** Claude Code
- **What I asked for:** Three improvements to the demo: automatic matching so that reporting a lost or found item finds likely matches on the other side and notifies me; replies in the chat so it isn't one-way; and a place to say where a found item can be claimed.
- **What it gave back:** Code for three features. (1) Matching: `matchesFor()` in `app_store.dart` scores open reports on the other side (lost vs found), 2 points for the same category and 1 point per shared word in the name, and counts a match at 2 or more. It adds a "Possible match" notification when I report an item. (2) Simulated replies: after I message someone else's report, a short scripted answer arrives after about 1.5 seconds and adds a "New reply" notification, because the app has no shared server. Inquiries now count people, not messages. (3) Claim location: found items have a `claimAt` field shown in the item details. It also showed the sender name and the time on chat messages, and changed time labels to show a full date after a week.
- **What I kept, what I changed, and why:** I kept all three features, because they fix gaps in the demo: chat had no replies, the "possible match" notification was fake demo data, and found items had no claim location. The saved-data key was also bumped to `findit_data_v2`, so old browser saves don't hide the new demo data.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/dc1c7688a2eca9310f607d6fce05bee78f7897ec

### 2026-10-05 - Hide contact info, fake demo user and add categories

- **Tool:** Claude Code
- **What I asked for:** Make the demo safe for a public repository, and add categories to the report form: replace the demo user's real-looking details with fake ones, stop showing the reporter's contact info to other users in the chat, and let the person reporting an item pick a category.
- **What it gave back:** (1) Demo user: the name, student ID and phone number in `mock_data.dart` were replaced with fake ones ("Juan Dela Cruz", `0000-00000`, `0900 000 0000`). (2) Private contact info: the banner in `chat_screen.dart` no longer prints `item.contact`. It now says the reporter's contact info is private, and tells the owner of a report to ask for identifying details before handing the item over. (3) Categories: a fixed list of nine categories in `item.dart` (ID card, keys, bag, wallet, electronics, tumbler, umbrella, clothing, other), a required Category dropdown in `report_item_screen.dart`, the chosen category stored as the item's first tag, and new icons for wallets, clothing and electronics.
- **What I kept, what I changed, and why:** I kept everything in this commit: the category chips, the filter sheet (status, location, sort by date, show resolved), the active filter count on the button, the item count, and the grey `[RESOLVED]` tag. The Home screen only had an All/Lost/Found dropdown before, which made it hard to find one item among many reports, so I wanted filters that match how people look for a lost item. I put category on the chips and kept it out of the sheet so there is only one place to pick it. I removed the old `browseItems` list from the store, because the screen now does the filtering and decides whether resolved items show.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/ee2c64b2d96a3fd325b58b7f3608b6e66a89e2bb

### 2026-10-05 - Accessibility fixes, pull to refresh and small animations

- **Tool:** Claude code
- **What I asked for:** Make the app easier to use and read (colour contrast, bigger tap targets, screen reader support), add pull to refresh, and add small animations.
- **What it gave back:** The colours in `app_colors.dart` were adjusted in both modes (for example `muted` and `hint` are darker in day mode, and `navy` is lighter in night mode), and a new `onNavy` colour is used for text on navy buttons. Pull to refresh was added with `AppStore.refresh()`, which re-reads the saved data, and the claim-resume code was moved into `_resumePendingClaims()`. A mouse can now drag lists like a finger (`scrollBehavior` in `app.dart`) so refresh works on a laptop. It also added `fade_slide_in.dart` for the animations and `test/accessibility_test.dart`.
- **What I kept, what I changed, and why:** I kept all of it. The old grey text was hard to read on a light background, and pull to refresh makes the demo feel like a real app. A change on one of these tap-target changes, because the category chips were cut off at the edge.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/e3e40fd826c2e15ba1159b0b5a58d1dd58fbce65

### 2026-10-05 - Photo animation from cards to details and full screen

- **Tool:** Claude Code
- **What I asked for:** Animate an item's photo so it grows from its card into the details page, and then into the full-screen view.
- **What it gave back:** A `heroTag` that is passed through `ItemCard`, `ItemPhoto`, `ItemDetailsScreen`, `MyItemCard` and `PhotoViewer`, and `ItemPhoto.tagFor()`, which gives each tab its own tag (Home and My Items stay alive at the same time, so the same item needs a different tag in each). The animation is switched off when the device asks for reduced motion. It also added `test/hero_test.dart`, which checks that the photo flies from a Home card and a My Items card, that it doesn't when reduced motion is on, and that no errors come up when going back.
- **What I kept, what I changed, and why:** I kept the animation and the test. It makes moving between a list and the details feel connected, and it respects the reduced motion setting.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/9366bea221a9fb09f92edca94fdc1276ab853adb

## 2. Where the AI got it wrong

### Case 1 - The category chips were cut off at the edge

- **What it gave me:** On the Home screen, the category chips (All plus nine categories) were in a single row that scrolled sideways.
- **What was wrong with it:** The row was wider than the screen, so the last chips were cut off at the edge and hard to find without scrolling sideways.
- **What I did instead:** I had the row changed to wrap onto more lines, so every chip shows on screen, and made each chip's tap area at least 48 px tall.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/8cf5d243f1b139e8d4063901633e7fff5ce2cbe1

### Case 2 - Every chat message counted as a new inquiry

- **What it gave me:** A chat where each message I sent on someone else's report added 1 to that report's inquiry count, and nobody ever replied.
- **What was wrong with it:** The count is supposed to show how many people asked about an item, but one person sending three messages made it show three. The chat was also one-way, so it felt unfinished.
- **What I did instead:** I changed it so only a person's first message on someone else's report counts as an inquiry, and added short scripted replies so the chat isn't one-way, because the app has no server for real users to talk through.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/dc1c7688a2eca9310f607d6fce05bee78f7897ec

### Case 3 - The demo data looked like a real person

- **What it gave me:** A demo user and an ID card item with a real-looking name, student ID number and phone number, and a chat banner that printed the reporter's contact details.
- **What was wrong with it:** The repository is public, so data that looks real is a privacy problem, and showing contact details broke the "contact info stays private" promise on the report form.
- **What I did instead:** I replaced the demo details with obviously fake ones ("Juan Dela Cruz", `0000-00000`, `0900 000 0000`) and changed the chat banner so it no longer shows contact info.
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/ee2c64b2d96a3fd325b58b7f3608b6e66a89e2bb

## 3. Who wrote what

At least a fifth of this project is written by me.

### Written by me

- **File:** `test/widget_test.dart`
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/ffe00bd2547a434f4bdd7b7421385a99328e75aa
- **What it does and why we kept it:** The test starts the app, checks that the splash screen shows "University Lost & Found", waits for it to finish, taps "Sign In", and checks that the Home screen with "Lost & Found Items" appears. I wanted a simple test that proves the main path, from splash to login to Home, still works after a change.

### The AI-written part I understand best

- **File:** `lib/data/app_store.dart` (`matchesFor` and `addItem`)
- **Commit:** https://github.com/aioicchi/HAU-6ADET-FindIt/commit/dc1c7688a2eca9310f607d6fce05bee78f7897ec
- **What it does and why it is built this way:** This is the automatic matching. When I report an item, `matchesFor` looks at every open report on the other side (lost vs found) and gives each one a score: 2 points if it has the same category, and 1 point for each word of three or more letters that the two names share. Anything with 2 or more points counts as a possible match, sorted by best score and then newest. `addItem` then adds a "Possible match" notification for the best one. We kept it because it is simple, needs no server, and replaced a notification that used to be fake demo data.
