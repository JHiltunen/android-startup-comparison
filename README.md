# Android Startup Comparison Script

**Version: 1.0.0**

This repository contains a Bash script for comparing the cold startup times of two Android applications. The script uses ADB and `logcat` to capture launch timing data based on the `Displayed` line that Android logs when the first activity is shown.

Although originally developed to compare Xamarin.Forms and .NET MAUI apps, the script works with **any Android applications**, making it a general-purpose startup measurement tool.

## Features
- Measures cold startup time using `logcat` output
- Supports both `+XXXms` and `+X.XXXs` formats (e.g., `+832ms`, `+1s263ms`)
- Repeats the measurement N times (default: 5)
- Calculates average launch time for each app
- Suitable for physical Android devices and emulators

## Prerequisites
- Bash environment (Linux, macOS, WSL, or Git Bash on Windows)
- Android Debug Bridge (ADB) installed and working
- Two Android apps installed on the same device

## Usage

1. Open the script file `compare_startup_times.sh`
2. Set the package names of the two apps to compare:
   ```bash
   PACKAGES=("com.example.app1" "com.example.app2")
   ```
3. Make the script executable:
   ```bash
   chmod +x compare_startup_times.sh
   ```
4. Run the script:
   ```bash
   ./compare_startup_times.sh
   ```
5. The results will be saved to `startup_comparison_results.txt`

## Output
Example output:
```
Run	App 1 (ms)	App 2 (ms)
1	732	582
2	751	610
...
Average:
App 1: 740 ms
App 2: 598 ms
```

## Changelog

**1.0.0**
- Initial release
- Supports measuring startup times of two Android apps using ADB and logcat
- Calculates averages over configurable repeat count
- Compatible with both `+XXXms` and `+X.XXXs` log formats

## Acknowledgements
This script is based on measurement principles described by Jonathan Peppers in his [maui-profiling](https://github.com/jonathanpeppers/maui-profiling) repository.  
Although the original project does not include a script like this, the idea of using `logcat` to measure cold startup time by parsing the `Displayed` log line inspired the approach used here.
