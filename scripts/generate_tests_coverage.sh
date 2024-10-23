echo "Running tests and generating coverage report..."

echo "Running tests..."
fvm flutter test test/unit --coverage

echo "Generating coverage report..."
genhtml coverage/lcov.info -o coverage/html

echo "Opening coverage report..."
cd coverage/html

echo "Navigated to coverage/html directory"
echo "Opening coverage report in browser..."
google-chrome index.html
