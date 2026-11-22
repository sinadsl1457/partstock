plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.taektoy.partstock"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Play에 올리면 바꿀 수 없다(11/22 사용자 결정: NowStation과 같은 com.taektoy.*)
        applicationId = "com.taektoy.partstock"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Play 업로드 키: CI(GitHub Actions)가 비밀값으로 넘긴다(ORG_GRADLE_PROJECT_RELEASE_*). 키는 레포에 두지 않는다.
    // 값이 없으면(로컬 빌드) 디버그 키로 서명해 flutter run --release가 그대로 된다.
    val releaseStore = findProperty("RELEASE_STORE_FILE") as String?
    signingConfigs {
        if (releaseStore != null) {
            create("release") {
                storeFile = file(releaseStore)
                storePassword = findProperty("RELEASE_STORE_PASSWORD") as String
                keyAlias = findProperty("RELEASE_KEY_ALIAS") as String
                keyPassword = findProperty("RELEASE_KEY_PASSWORD") as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName(if (releaseStore != null) "release" else "debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
