# =============================================================================
# Makefile for Flutter Development Tasks
# =============================================================================
# 
# This Makefile provides convenient commands for common Flutter development tasks.
# Run 'make help' to see all available commands.
#
# =============================================================================

.PHONY: build_runner clean watch rebuild help test test-coverage test-coverage-combined analyze format fix fix-imports \
        pub-get gen-l10n icons splash barrel-files web-build web-build-wasm web-run fvm-install

# Run build_runner build without toJson warnings
build_runner:
	@echo "Running build_runner (filtering serialization warnings)..."
	@fvm dart run build_runner build --delete-conflicting-outputs 2>&1 | grep -v "must provide a \`toJson()\` method" | grep -v "It is programmer's responsibility to make sure" | grep -v "Configuring \`retrofit_generator:retrofit\`" || true

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@fvm dart run build_runner clean

# Full rebuild: flutter clean, pub get, and build_runner
rebuild:
	@echo "Running full rebuild (flutter clean + pub get + build_runner)..."
	@fvm flutter clean
	@fvm flutter pub get
	@fvm dart run build_runner build --delete-conflicting-outputs 2>&1 | grep -v "must provide a \`toJson()\` method" | grep -v "It is programmer's responsibility to make sure" | grep -v "Configuring \`retrofit_generator:retrofit\`" || true

# Watch for changes
watch:
	@echo "Running build_runner in watch mode (filtering serialization warnings)..."
	@fvm dart run build_runner watch --delete-conflicting-outputs 2>&1 | grep -v "must provide a \`toJson()\` method" | grep -v "It is programmer's responsibility to make sure" | grep -v "Configuring \`retrofit_generator:retrofit\`" || true

# =============================================================================
# Testing & Quality
# =============================================================================

# Run unit tests
test:
	@echo "Running tests..."
	@fvm flutter test

# Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	@fvm flutter test --coverage
	@echo "Coverage report generated in coverage/lcov.info"

# Run combined coverage (unit + integration tests)
test-coverage-combined:
	@echo "Running combined coverage (unit + integration tests)..."
	@rm -f coverage/combined_lcov.info coverage/test_lcov.info coverage/integration_test_lcov.info
	@echo "Running unit tests with coverage..."
	@fvm flutter test --coverage
	@mv coverage/lcov.info coverage/test_lcov.info
	@echo "Running integration tests with coverage..."
	@fvm flutter test integration_test --coverage -d macos
	@mv coverage/lcov.info coverage/integration_test_lcov.info
	@echo "Combining coverage reports..."
	@lcov -a coverage/test_lcov.info -a coverage/integration_test_lcov.info -o coverage/combined_lcov.info
	@echo "Generating HTML report..."
	@genhtml coverage/combined_lcov.info -o coverage/html
	@echo "Combined coverage report generated at coverage/html/index.html"
	@echo "Opening coverage report..."
	@if command -v open > /dev/null; then open coverage/html/index.html; \
	elif command -v xdg-open > /dev/null; then xdg-open coverage/html/index.html; \
	elif command -v start > /dev/null; then start coverage/html/index.html; \
	else echo "Please open coverage/html/index.html manually"; fi

# Analyze code
analyze:
	@echo "Analyzing code..."
	@fvm dart analyze

# Format code (excluding generated files)
format:
	@echo "Formatting code (excluding .g.dart and .freezed.dart files)..."
	@find . \( -path "./packages" -prune \) -o \( -path "./.dart_tool" -prune \) -o \( -path "./lib/l10n/gen" -prune \) -o \( -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" -print \) | xargs fvm dart format -l 120

# Apply dart fixes and check for const opportunities
fix:
	@echo "Applying dart fixes and checking for const opportunities..."
	@fvm dart fix --apply && fvm dart analyze && fvm dart analyze --no-fatal-infos 2>&1 | grep -E "(prefer_const|can be const)" || true

# Remove unused imports and apply import fixes
fix-imports:
	@echo "Removing unused imports and optimizing import statements..."
	@fvm dart fix --apply
	@echo "Done! Unused imports removed."

# =============================================================================
# Dependencies & Setup
# =============================================================================

# Get dependencies
pub-get:
	@echo "Getting dependencies..."
	@fvm flutter pub get

# Install project's Flutter version
fvm-install:
	@echo "Installing Flutter version from .fvmrc..."
	@fvm install

# =============================================================================
# Code Generation
# =============================================================================

# Generate localizations
gen-l10n:
	@echo "Generating localizations..."
	@fvm flutter gen-l10n

# Generate launcher icons
icons:
	@echo "Generating launcher icons..."
	@fvm flutter pub get
	@fvm flutter pub run flutter_launcher_icons

# Generate splash screen
splash:
	@echo "Generating splash screen..."
	@fvm flutter pub get
	@fvm dart run flutter_native_splash:create --path=flutter_native_splash.yaml

# Generate barrel files
barrel-files:
	@echo "Generating barrel files..."
	@fvm dart pub global activate index_generator
	@fvm dart pub global run index_generator
	@echo "Barrel files generated successfully!"

# =============================================================================
# Build & Run
# =============================================================================

# Build for web
web-build:
	@echo "Building for web..."
	@fvm flutter build web

# Build for web with WASM
web-build-wasm:
	@echo "Building for web with WASM..."
	@fvm flutter build web --wasm --dart-define=GOOGLE_MAPS_API_KEY_STAGING=$(GOOGLE_MAPS_API_KEY_STAGING) --dart-define=GOOGLE_MAPS_API_KEY_PROD=$(GOOGLE_MAPS_API_KEY_PROD)

# Run on Chrome (requires WEB_SSE_OAUTH_CLIENT_SECRET)
web-run:
	@echo "Running on Chrome..."
	@fvm flutter run -d chrome --web-port=1337 --dart-define=WEB_SSE_OAUTH_CLIENT_SECRET=$(WEB_SSE_OAUTH_CLIENT_SECRET) --dart-define=GOOGLE_MAPS_API_KEY_STAGING=$(GOOGLE_MAPS_API_KEY_STAGING) --dart-define=GOOGLE_MAPS_API_KEY_PROD=$(GOOGLE_MAPS_API_KEY_PROD)

# =============================================================================
# Help
# =============================================================================

# Show help
help:
	@echo "==================================================================="
	@echo "Flutter Development Commands"
	@echo "==================================================================="
	@echo ""
	@echo "Code Generation:"
	@echo "  make build_runner     - Run build_runner (without warnings)"
	@echo "  make watch            - Watch mode for build_runner"
	@echo "  make clean            - Clean generated files"
	@echo "  make rebuild          - Full rebuild (clean + pub get + build_runner)"
	@echo "  make gen-l10n         - Generate localizations"
	@echo "  make icons            - Generate launcher icons"
	@echo "  make splash           - Generate splash screen"
	@echo "  make barrel-files     - Generate barrel files (index_generator)"
	@echo ""
	@echo "Testing & Quality:"
	@echo "  make test             - Run unit tests"
	@echo "  make test-coverage    - Run tests with coverage"
	@echo "  make test-coverage-combined - Combined coverage (unit + integration)"
	@echo "  make analyze          - Analyze code"
	@echo "  make format           - Format code (excludes generated files)"
	@echo "  make fix              - Apply dart fixes and check const opportunities"
	@echo "  make fix-imports      - Remove unused imports"
	@echo ""
	@echo "Dependencies & Setup:"
	@echo "  make pub-get          - Get dependencies"
	@echo "  make fvm-install      - Install Flutter version from .fvmrc"
	@echo ""
	@echo "Build & Run:"
	@echo "  make web-build        - Build for web"
	@echo "  make web-build-wasm   - Build for web with WASM"
	@echo "  make web-run          - Run on Chrome (needs WEB_SSE_OAUTH_CLIENT_SECRET)"
	@echo ""
	@echo "==================================================================="

