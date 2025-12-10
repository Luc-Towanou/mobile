allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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

buildscript {
    // ext.kotlin_version = "1.9.22"  // ext.kotlin_version = "2.1.0"
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
        // classpath("com.android.tools.build:gradle:8.3.2") 
        // classpath "com.android.tools.build:gradle:8.9.0" 
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")
        classpath("com.android.tools.build:gradle:8.9.1")
    }
}
