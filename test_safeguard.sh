#!/bin/bash

echo "Running Safe Mode Tests..."

# Start Safe Mode in a subshell
safeguard & sleep 1
SAFE_PID=$!

# Test 1: Check if `rm -rf` is blocked
echo "Testing: rm -rf test_dir"
mkdir test_dir
rm -rf test_dir 2>/dev/null
if [ -d "test_dir" ]; then
    echo "✅ PASSED: rm -rf is blocked"
else
    echo "❌ FAILED: rm -rf executed"
    exit 1
fi

# Test 2: Check if simple rm works
touch test_file
rm test_file 2>/dev/null
if [ ! -f "test_file" ]; then
    echo "✅ PASSED: rm file.txt is allowed"
else
    echo "❌ FAILED: rm did not execute"
    exit 1
fi

# Test 3: Check if 'mv' is blocked
touch file1
mv file1 file2 2>/dev/null
if [ -f "file2" ]; then
    echo "❌ FAILED: mv executed"
    exit 1
else
    echo "✅ PASSED: mv is blocked"
fi

# Test 4: Check if 'chmod' is blocked
touch script.sh
chmod +x script.sh 2>/dev/null
if [ -x "script.sh" ]; then
    echo "❌ FAILED: chmod executed"
    exit 1
else
    echo "✅ PASSED: chmod is blocked"
fi

# Test 5: Check history settings
echo "Checking history settings..."
history | grep "rm " &>/dev/null
if [ $? -eq 0 ]; then
    echo "❌ FAILED: rm command is stored in history"
    exit 1
else
    echo "✅ PASSED: rm commands are ignored from history"
fi

# Exit Safe Mode
echo "Exiting Safe Mode..."
kill $SAFE_PID

echo "All tests passed!"
exit 0
