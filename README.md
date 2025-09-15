# Vertical Movie Explorer

## How To Run

This app build using `Flutter 3.29.3`, Dart `3.7.2`, DevTools `2.42.3`. To run this app make sure flutter is installed, then execute

```
flutter pub get
```

to install dependencies, then execute

```
flutter run
```

to run the app

## App Features

| Home with vertical scrolling                                         | Movie Detail                                             | Actor Detail                                        |
| -------------------------------------------------------------------- | -------------------------------------------------------- | --------------------------------------------------- |
| First screen shown, tapping on "View Movie" will open `Movie Detail` | Tapping on cast profile picture will open `Actor Detail` | Tapping on movie thumbnail will open `Movie Detail` |
| ![home](screenshot/home.jpg)                                         | ![movie](screenshot/home.jpg)                            | ![actor](screenshot/home.jpg)                       |

## Code Infrastructure

The code infrastructure in this app is using State, which is the simplest out of all, following KISS principle . Widgets are stored inside `lib/features` folder, meanwhile models and services stored inside `lib/data` folder
