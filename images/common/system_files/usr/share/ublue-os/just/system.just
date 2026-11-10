# Clean up system journal logs older than 3 days to reclaim disk space
[group('Diagnostics')]
prune-logs:
    @echo "🧹 Pruning journal logs older than 3 days..."
    @journalctl --vacuum-time=3d

# Follow and stream live systemd user journal logs in real-time
[group('Diagnostics')]
logs:
    @journalctl --user -e -f
