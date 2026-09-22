#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/../.." && pwd)

. "$repo_root/.chezmoitemplates/userchrome-deploy.sh.tmpl"

failures=0

assert_true() {
    if [ "$1" = "true" ]; then
        echo "PASS: $2"
    else
        echo "FAIL: $2"
        failures=$((failures + 1))
    fi
}

assert_eq() {
    if [ "$1" = "$2" ]; then
        echo "PASS: $3"
    else
        echo "FAIL: $3 (expected '$2', got '$1')"
        failures=$((failures + 1))
    fi
}

# Test 1: Install-section profile takes precedence over legacy Default=1
tmp1=$(mktemp -d)
mkdir -p "$tmp1/LibreWolf/Profiles/stale.default"
mkdir -p "$tmp1/LibreWolf/Profiles/active.default-release"
cat > "$tmp1/LibreWolf/profiles.ini" <<'EOF'
[Profile1]
Name=default
IsRelative=1
Path=Profiles/stale.default
Default=1

[InstallABC123]
Default=Profiles/active.default-release
Locked=1

[General]
StartWithLastProfile=1
Version=2
EOF

deploy_userchrome "LibreWolf|$tmp1/LibreWolf" "TEST_CSS_1"
if [ -f "$tmp1/LibreWolf/Profiles/active.default-release/chrome/userChrome.css" ]; then
    assert_true "true" "Install-section profile: chrome dir created for active profile"
    content=$(cat "$tmp1/LibreWolf/Profiles/active.default-release/chrome/userChrome.css")
    assert_eq "$content" "TEST_CSS_1" "Install-section profile: content written correctly"
else
    assert_true "false" "Install-section profile: chrome dir created for active profile"
fi
if [ -f "$tmp1/LibreWolf/Profiles/stale.default/chrome/userChrome.css" ]; then
    assert_true "false" "Install-section profile: stale profile NOT written"
else
    assert_true "true" "Install-section profile: stale profile NOT written"
fi

# Test 2: fallback to legacy Default=1 when no Install section exists
tmp2=$(mktemp -d)
mkdir -p "$tmp2/Firefox/Profiles/legacy.default"
cat > "$tmp2/Firefox/profiles.ini" <<'EOF'
[Profile0]
Name=default
IsRelative=1
Path=Profiles/legacy.default
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF

deploy_userchrome "Firefox|$tmp2/Firefox" "TEST_CSS_2"
if [ -f "$tmp2/Firefox/Profiles/legacy.default/chrome/userChrome.css" ]; then
    assert_true "true" "Legacy fallback: chrome dir created for Default=1 profile"
else
    assert_true "false" "Legacy fallback: chrome dir created for Default=1 profile"
fi

# Test 3: browser dir missing entirely -> no error, nothing written
tmp3=$(mktemp -d)
deploy_userchrome "Ghost|$tmp3/Ghost" "TEST_CSS_3"
assert_true "true" "Missing browser dir: no exception thrown"

# Test 4: profiles.ini with no resolvable profile -> warning, no crash, no file written
tmp4=$(mktemp -d)
mkdir -p "$tmp4/Floorp"
cat > "$tmp4/Floorp/profiles.ini" <<'EOF'
[General]
StartWithLastProfile=1
Version=2
EOF

deploy_userchrome "Floorp|$tmp4/Floorp" "TEST_CSS_4" 2>/dev/null
if find "$tmp4" -name 'userChrome.css' | grep -q .; then
    assert_true "false" "Unresolvable profile: nothing written"
else
    assert_true "true" "Unresolvable profile: nothing written"
fi

# Test 5: Path= line appearing before Default=1 in the same section still resolves
# (this ordering is what real profiles.ini files use — Path is listed before Default)
tmp5=$(mktemp -d)
mkdir -p "$tmp5/Waterfox/Profiles/order-check.default"
cat > "$tmp5/Waterfox/profiles.ini" <<'EOF'
[Profile0]
Name=default
IsRelative=1
Path=Profiles/order-check.default
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF

deploy_userchrome "Waterfox|$tmp5/Waterfox" "TEST_CSS_5"
if [ -f "$tmp5/Waterfox/Profiles/order-check.default/chrome/userChrome.css" ]; then
    assert_true "true" "Path-before-Default ordering: still resolves correctly"
else
    assert_true "false" "Path-before-Default ordering: still resolves correctly"
fi

rm -rf "$tmp1" "$tmp2" "$tmp3" "$tmp4" "$tmp5"

if [ "$failures" -gt 0 ]; then
    echo ""
    echo "$failures test(s) failed."
    exit 1
else
    echo ""
    echo "All tests passed."
    exit 0
fi
