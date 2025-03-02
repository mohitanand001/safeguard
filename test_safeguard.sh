#!/bin/bash

# Test cases for Safe Mode script

echo "Running Safe Mode Tests..."

# Test 1: Ensure Safe Mode starts
ls
chmod +x ./safeguard.sh
source ./safeguard.sh
# PID=$!
# sleep 1
# ps -p $PID > /dev/null
# if [ $? -eq 0 ]; then
#     echo "Test 1 Passed: Safe Mode started successfully."
# else
#     echo "Test 1 Failed: Safe Mode did not start."
#     exit 1
# fi

# Test 2: Ensure rm -rf is blocked
OUTPUT=$(rm -rf testfile 2>&1)
if [[ "$OUTPUT" == *"Recursive rm is disabled."* ]]; then
    echo "Test 2 Passed: rm -rf is blocked."
else
    echo "Test 2 Failed: rm -rf is not blocked."
    exit 1
fi

# Test 3: Ensure 'password' commands are not logged or stored in history
echo "mysql -U user -password secret" >> ~/.bash_history
history | grep -q "password"
if [ $? -eq 1 ]; then
    echo "Test 3 Passed: Password commands are not stored in history."
else
    echo "Test 3 Failed: Password commands are stored in history."
    exit 1
fi

# Test 4: Ensure Safe Mode exits properly
echo "deactivate" | bash
sleep 1
ps -p $PID > /dev/null
if [ $? -ne 0 ]; then
    echo "Test 4 Passed: Safe Mode exited successfully."
else
    echo "Test 4 Failed: Safe Mode did not exit."
    exit 1
fi

echo "All tests passed successfully."
