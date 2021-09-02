# Android Releases

## On App store

----

### v4 as APK.
- Released to store
25/Aug/2021 (Could not get a new review until this was published)
- Approved by Play
27/July/2021 (not released due to internal...)
- Submitted for Review
23/July/2021
- Internal and closed testing
?
- Codebase PR & Branch
PR #934, image-patch
- Release Notes
```md
Default language – en-GB
Hello World! Welcome to Kalda, the LGBTQIA+ mental health and wellbeing app.
```
- Comments:
Not promoted
- Issues:
No links to registration, which is still external (webapp only)

----

## In Open Testing

----

### versionName 5.2 code versionCode 7 as APK
- Purpose:
Undo breaking changes of 5.1 but resolve issues of notification refresh in 5.0
- Released to open testing
- Approved by Play
- Submitted for Review
- Submitted for internal testing and closed review
02/Sept/2021 12:40
- Codebase PR & Branch
PR #1035 -b order-comments
- Release Notes
```md
Default language – en-GB
Kalda Update
- Orders the notification view so your comment and it's replies comes first.
- Notifications update more regularly
- Bug fixes.
```
- Comments:

- Issues:
----


### versionName 5.0 code vC 6 as APK
- Released to open testing
25/Aug/2021 (pm)
- Approved by Play
	@@ -76,47 +39,3 @@ Update!
- Comments:
Turnaround was just under 24 hours.
Branch not actually merged until after APK released, which I won't do again.
- Issues:
Links for registration broken from mobile APP.

----

## In Closed and Internal

----

### v5.1 
- Purpose:
Fixes links but also truncated notifications and changed post route
- issues:
Breaking API change
- Status: 
Unreleased (internal and closed only)

.
.
.
.


# Make the APK

Update the version numbers in build.gradle
Make sure you tag somehow the release in the PR that is merged in so you know what PR it is equivalent to!
Update android-release-notes.md

```sh
Npm run frontend-build && npx cap copy android
npx cap open Android
Npx cap sync
```

In studio run it, press play
Connect mobile in debug mode to test
If happy update the versionName version and versionCode in android/app/build.gradle
In build menu go to generate signed APK. You need keycodes etc but you generate them according to the android docs
Find the release in kalda/android/app/release/app-release.apk

In kalda dev account: kaldadev@gmail.com go to [Play console](https://play.google.com/console/)
in Internal testing, create new release
