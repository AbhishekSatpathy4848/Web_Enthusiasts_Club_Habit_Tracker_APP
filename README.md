# Web_Enthusiasts_Club_Habit_Tracker_APP
App Project for Web Enthusiasts Club Recruitment - Task ID: Habit Tracker App

## How to install?
To install this application, please download the APK file provided below on your android device.
https://github.com/AbhishekSatpathy4848/Web_Enthusiasts_Club_Habit_Tracker_APP/blob/master/app-release.apk

## Technologies Used
- Flutter
- Dart
- Hive
- Firebase

## List of Implemented Features

### Login and Registration: 
- Login and Registration functionalities were implemented using the Firebase Authentication API. The app handles API responses related to incorrect passwords, invalid emails, weak passwords, network errors etc.

- Implemented Auto-Login. The user doesn't need to authenticate everytime the app is restarted. Their authentication state is checked everytime the app is opened and they are auto-logged in depending on the AuthState.

- The user can sign out of his account from the Profile page of the app.



https://user-images.githubusercontent.com/108116233/199284380-349a1767-908b-44ab-87bf-30ff53faf4e5.mov





<p> 
<img width="320" alt="Register" src="https://user-images.githubusercontent.com/108116233/199278968-48f88fc6-bd7e-42fc-b7e4-051f139f4028.png"><img width="320" alt="SignOut" src="https://user-images.githubusercontent.com/108116233/199280917-c34354fe-0021-4870-89d8-db966b323f2a.png">
</p>


### Tracking Habits:
- A habit can simply be created by clicking the plus button, filling in the Habit name and the number of Days the user wishes to take up that habit(Goal Days).
- Every habit must have a unique name and unique colour. The app wouldn't allow the user to create a habit with the same name and colour.
- The user can select the check box linked with every habit to mark its completion for the day. The checkbox resets every single day.
- Any habit can be deleted by simply clicking the bin icon. 


https://user-images.githubusercontent.com/108116233/199283440-2bcaf96f-40c5-4ecb-a2f8-3331a5a7446f.mov

https://user-images.githubusercontent.com/108116233/199292985-907a2d1e-aad1-46f5-b277-9cfd7e970ac8.mov

- Every Habit is tappable and supports two types of tap gestures:

  1. Single Tap: The user can now view every metric associated with each habit.
  
     - Success Rate: Measures how deligently the user completes his habits.
     - Progress Rate: Measures how far in the user is towards his goal.
     - Streaks: The calendar highlights all the streaks completed by the user. The habit's Current and Best Streaks are also mentioned along with their start dates.

  2. Long Press: The user can quickly glance through the most important metrics of any habit, its Success Rate and Progreess Rate.

https://user-images.githubusercontent.com/108116233/199294395-e46a756e-544b-4c75-8b8e-6b82d1d7a2c6.mov

<p>
<img width="320" alt="LongPress" src="https://user-images.githubusercontent.com/108116233/199281562-18035c93-ef02-4721-87a2-f2b8d89081c5.png">
<img width="320" alt="HabitDetails_1" src="https://user-images.githubusercontent.com/108116233/199296099-49cf89e8-0942-49f3-bb9e-e588166a716f.png">
<img width="320" alt="HabitDetails_2" src="https://user-images.githubusercontent.com/108116233/199296153-67b77708-d6c1-418d-b333-cd81af10651c.png">
</p>

- The app keeps track of the 'Goal Days' for every ongoing habit and moves them to the Completed Habit Section after the stipulated time.
- On selecting Stats from the bottom navigation bar, the combined stats of all habits can be viewed in the form of concentric rings, horizontal bar charts and tables.
<p><img width="320" alt="Rings_1" src="https://user-images.githubusercontent.com/108116233/199282100-6a9b833d-3e31-42e8-bb56-13b85823e462.png">
<img width="320" alt="Rings_2" src="https://user-images.githubusercontent.com/108116233/199282119-125d6418-b72c-498b-93a8-e8b541c99b1a.png">
<img width="320" alt="Ring_3" src="https://user-images.githubusercontent.com/108116233/199282139-55859769-148a-480f-927c-faa6e87280d9.png"></p>



https://user-images.githubusercontent.com/108116233/199285813-b7309c63-6069-4726-a623-1ccf523e8524.mov


- After every Habit is completed, it is moved to the Completed Habits section in the Profile page. The stats of the completed habits can also be viewed.


https://user-images.githubusercontent.com/108116233/199285394-547d8df4-bac2-4ae1-bb28-ff1234b2a935.mov


### Local Storage using Hive and Realtime Database using Firebase:
- Everytime the user signs into his account, data is loaded from Realtime Firebase Database into Hive. Any further addition or deletion of Habits are updated locally only in hive and not on Firebase. On signing out of the account, all the data from Hive is backed up to Firebase and the local storage (Hive) is cleared. Clearing Hive prevents the leakage of the prior users data into the account of the newly logged in user from the same device. Accessing Firebase only once during login to retrieve data and then switching to Hive for all other operations improves performance.

## List of Planned Features
- Reward the user with Points/Badges for completing habits and breaking streaks records. 
- Run a timer for each habit and increment habit count after that interval.

## List of known Bugs
- The UI doesn't scale appropriately in some devices.

## Operating System Used for Development: 
MacOS Monetery 12.6

## References:
- The Net Ninja - YouTube Channel - Flutter Tutorial for Beginners : https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ
- The Net Ninja - YouTube Channel - Flutter & Firebase App Tutorial  : https://www.youtube.com/watch?v=sfA3NWDBPZ4&list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC
- Flutter - YouTube Channel - Widget of the Week : https://www.youtube.com/watch?v=XawP1i314WM&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG
- Johannes Milke - YouTube Channel : https://www.youtube.com/c/JohannesMilke
- Firebase - Youtube Channel - Getting started with Firebase on Flutter : https://www.youtube.com/watch?v=EXp0gq9kGxI&t=855s
- Flutter Documentation : https://docs.flutter.dev/
- Johannes Milke - YouTube Channel - About Hive : https://www.youtube.com/watch?v=w8cZKm9s228&t=299s








