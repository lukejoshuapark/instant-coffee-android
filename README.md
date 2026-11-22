![icon](./icon.png)

# Instant Coffee (Android)

Instant Coffee (Android) extends [Instant Coffee](https://github.com/lukejoshuapark/instant-coffee) with
the Android SDK and Flutter.

Flutter is configured for Android development only (web and Linux desktop are
disabled), so `flutter doctor` passes cleanly.

Only `amd64` images are supported, as Google does not publish the Android SDK
build tools for `arm64` Linux.  On Apple Silicon, Docker Desktop will run the
image under emulation.

## Image URL

```url
ghcr.io/lukejoshuapark/instant-coffee-android:0.12.0
```

## Installed Software

Everything from the base Instant Coffee image is included, plus:

|Name|Type|Version|
|----|----|-------|
|Android SDK Build-Tools|💛 Utility|36.0.0|
|Android SDK Command-line Tools|💛 Utility|16111833|
|Android NDK|💛 Utility|28.2.13676358|
|Android SDK Platform|💛 Utility|36|
|Android SDK Platform-Tools|💛 Utility||
|Flutter|💙 Language/Runtime|3.50.1|
|OpenJDK|💙 Language/Runtime|21|

## Project Versions

The image ships with Gradle, the Android Gradle Plugin (AGP) and Kotlin
dependencies already downloaded.  To get the benefit, your project's
`android/` directory should use the same versions as a fresh `flutter create`:

- **Gradle wrapper:** `9.5.0` (`gradle/wrapper/gradle-wrapper.properties`)
- **AGP:** `9.3.1` (`settings.gradle.kts`)
- **Kotlin:** `2.4.20` (`settings.gradle.kts`)
- **compileSdk / targetSdk:** `36`, **minSdk:** `24`
- **ndkVersion:** `28.2.13676358`
- **Java:** 17 or newer (the image provides 21)

Other versions still work, but Gradle will download them on every fresh
container.  The easiest way to stay in sync is to keep `compileSdk`, `ndkVersion`
etc. set to the `flutter.*` defaults the template generates.

## CI Recommendations

- Cache `~/.pub-cache` and `~/.gradle/caches` between runs, keyed on
  `pubspec.lock` and your Gradle files.
- Run `flutter pub get` once, then pass `--no-pub` to later `flutter` commands.
- Set `GRADLE_OPTS=-Dorg.gradle.daemon=false` in CI. A daemon only pays off
  across repeated builds (the image leaves it on for dev containers).
- Use `--target-platform android-arm64` for builds that don't ship to the Play
  Store. Otherwise release builds compile Dart once per CPU type (three times).
- Run `flutter analyze` and `flutter test` before the Android build so failures
  surface early and cheaply.
- Don't run `flutter doctor` in every job. The image is already verified at
  build time.

## Dev Container Template

Place this in a `.devcontainer/devcontainer.json` file in your project to use
Instant Coffee (Android).

```json
{
	"image": "ghcr.io/lukejoshuapark/instant-coffee-android:0.12.0",
	"runArgs": [ "--add-host", "host.docker.internal:host-gateway" ],
	"mounts": [
		"source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind",
		"source=claude-code-config,target=/root/.claude,type=volume"
	],
	"containerEnv": {
		"CLAUDE_CONFIG_DIR": "/root/.claude"
	},
	"customizations": {
		"vscode": {
			"extensions": [
				"Dart-Code.dart-code",
				"Dart-Code.flutter",
				"dbaeumer.vscode-eslint",
				"eamodio.gitlens",
				"golang.go",
				"hashicorp.terraform",
				"rust-lang.rust-analyzer",
				"tamasfe.even-better-toml"
			],
			"settings": {
				"js/ts.preferences.quoteStyle": "double",
				"editor.tabSize": 4,
				"editor.insertSpaces": false,
				"editor.detectIndentation": false,
				"[rust]": {
					"editor.insertSpaces": true
				},
				"[yaml]": {
					"editor.insertSpaces": true,
					"editor.tabSize": 2
				},
				"[dart]": {
					"editor.insertSpaces": true,
					"editor.tabSize": 2
				},
				"files.insertFinalNewline": true,
				"files.trimTrailingWhitespace": true,
				"remote.autoForwardPorts": false
			}
		}
	}
}
```
