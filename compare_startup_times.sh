#!/bin/bash

# Package names of the two apps to compare
PACKAGES=("com.example.app1" "com.example.app2")
REPEAT_COUNT=5
USER_ID=0
OUTPUT_FILE="startup_comparison_results.txt"

echo "Android Startup Time Comparison" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE
printf "Run\tApp 1 (ms)\tApp 2 (ms)\n" >> $OUTPUT_FILE

declare -a TIMES_APP1
declare -a TIMES_APP2

extract_ms() {
    local input="$1"
    local value=0
    if [[ $input =~ \+([0-9]+)s([0-9]+)ms ]]; then
        value=$((${BASH_REMATCH[1]} * 1000 + ${BASH_REMATCH[2]}))
    elif [[ $input =~ \+([0-9]+)ms ]]; then
        value=${BASH_REMATCH[1]}
    fi
    echo $value
}

for i in $(seq 1 $REPEAT_COUNT); do
    echo "Measurement $i/$REPEAT_COUNT"

    # App 1
    adb logcat -c
    adb shell am force-stop --user $USER_ID ${PACKAGES[0]}
    adb shell monkey -p ${PACKAGES[0]} -c android.intent.category.LAUNCHER 1 > /dev/null
    sleep 4
    LINE1=$(adb logcat -d | grep "Displayed" | grep "${PACKAGES[0]}" | head -n 1)
    VAL1=$(extract_ms "$LINE1")
    TIMES_APP1+=($VAL1)

    # App 2
    adb logcat -c
    adb shell am force-stop --user $USER_ID ${PACKAGES[1]}
    adb shell monkey -p ${PACKAGES[1]} -c android.intent.category.LAUNCHER 1 > /dev/null
    sleep 4
    LINE2=$(adb logcat -d | grep "Displayed" | grep "${PACKAGES[1]}" | head -n 1)
    VAL2=$(extract_ms "$LINE2")
    TIMES_APP2+=($VAL2)

    printf "$i\t$VAL1\t$VAL2\n" >> $OUTPUT_FILE
done

# Calculate averages
SUM1=0
SUM2=0
for j in $(seq 0 $(($REPEAT_COUNT - 1))); do
    SUM1=$(($SUM1 + ${TIMES_APP1[$j]}))
    SUM2=$(($SUM2 + ${TIMES_APP2[$j]}))
done

AVG1=$(($SUM1 / $REPEAT_COUNT))
AVG2=$(($SUM2 / $REPEAT_COUNT))

echo "" >> $OUTPUT_FILE
echo "Average:" >> $OUTPUT_FILE
printf "App 1: $AVG1 ms\n" >> $OUTPUT_FILE
printf "App 2: $AVG2 ms\n" >> $OUTPUT_FILE

echo "Comparison complete. Results saved to $OUTPUT_FILE"
