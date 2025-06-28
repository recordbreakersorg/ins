# Intranet of schools

The intranet of schools is a flutter project worked on by the 'Record Breakers'.
It is a flutter application made to work on android, linux and the web. It communicates
with a web backend via hooks exported from lib/backend.dart.

## project structure

source code in lib/, arb translations at lib/l19n, backend models at lib/models/ . utility 
widgets at lib/widgets/, utilities at lib/utils, app at lib/app.dart, theme at lib/theme.dart.

## startup

When the app startups, the app state is loaded using utilities at lib/appstate.dart
Where is stored the session, user, and other date.

When a user has signin or signup using the two assistant pages folders at lib/sign/signup/ and lib/sign/signin/
a session and/or user is created and saved in appstate.
If the user is login, depending if he integrated school or not and the role in the school,
it opens the set of pages at lib/pages/dashboard/*/.

## assets

app assets are at assets, icons at assets/icons/ and the app icon at assets/icons/is.png
