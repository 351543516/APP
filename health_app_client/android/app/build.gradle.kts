import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.health_app_client"
    compileSdk = flutter.compileSdkVersion
    ndkVersion =  "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    tasks.withType<KotlinCompile> {
        kotlinOptions {
            jvmTarget = JavaVersion.VERSION_11.toString()
        }
    }

    signingConfigs {
        create("releaseConfig") {
            storeFile = file("my-release-key.jks")
            storePassword = "LIhua8851580426"
            keyAlias = "my-key-alias"
            keyPassword = "LIhua8851580426"
        }
    }

    defaultConfig {
        renderscriptTargetApi = 21
        renderscriptSupportModeEnabled = true
        applicationId = "com.example.health_app_client"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("releaseConfig")
            isMinifyEnabled = true // 开启代码缩减
            isShrinkResources = true // 开启资源缩减
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}