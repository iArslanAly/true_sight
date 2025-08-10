// 🔧 Global build configuration
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Firebase Crashlytics Gradle Plugin
        classpath("com.google.firebase:firebase-crashlytics-gradle:2.9.9")

        // ✅ Google Services (required for Firebase Auth, Messaging, etc.)
        classpath("com.google.gms:google-services:4.4.1")

        
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
