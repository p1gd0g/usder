# p1gd0g flutte template

## build

```
$ENV:build_vsn='0.5.7'
.\script\deploy.ps1 -vsn $ENV:build_vsn
```

## generate icon

1. Setup the config file

Run the following command to create a new config automatically:

```shell
dart run flutter_launcher_icons:generate
```

This will create a new file called `flutter_launcher_icons.yaml` in your `flutter` project's root directory.

2. Run the package

After setting up the configuration, all that is left to do is run the package.

```shell
flutter pub get
dart run flutter_launcher_icons
```

## riverpod

```
dart run build_runner watch -d
```