@echo off
setlocal enabledelayedexpansion

set "GRADLE_HOME=%~dp0gradle\wrapper"
set "JAVA_EXE=%JAVA_HOME%\bin\java.exe"
if "%JAVA_EXE%"=="" set "JAVA_EXE=java"

"%JAVA_EXE%" -Dorg.gradle.wrapper.daemon=true -classpath "%GRADLE_HOME%\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %*