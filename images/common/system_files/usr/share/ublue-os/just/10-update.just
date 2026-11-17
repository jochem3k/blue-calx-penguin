# vim: set ft=make :

alias upgrade := update

# Update system, flatpaks, and containers all at once
[group('System')]
update:
    @sudo /usr/bin/uupd

# Show active bootc deployment and build metadata
[group('System')]
status:
    @echo "Image: $(cat /usr/share/calx/image-name 2>/dev/null || echo unknown)"
    @echo "Built: $(cat /usr/share/calx/build-timestamp 2>/dev/null || echo unknown)"
    @bootc status
