# Sync and apply your local dotfile configurations via Chezmoi
[group('Chezmoi')]
apply:
    @echo "✨ Applying dotfiles..."
    @chezmoi apply

# Pull recent dotfile updates from your remote repository and apply them
[group('Chezmoi')]
pull:
    @echo "📥 Pulling changes from remote..."
    @chezmoi git pull
    @echo "✨ Applying updates..."
    @chezmoi apply

# Stage, commit, and push local dotfile updates
[group('Chezmoi')]
push msg="update dotfiles":
    @echo "🗂️ Staging local changes..."
    @chezmoi re-add
    @chezmoi git add .
    @echo "✍️ Committing: {{ msg }}"
    @chezmoi git -- commit -m "{{ msg }}"
    @echo "📤 Pushing to remote..."
    @chezmoi git push

# Clean up system journal logs older than 3 days to reclaim disk space
[group('Diagnostics')]
prune-logs:
    @echo "🧹 Pruning journal logs older than 3 days..."
    @journalctl --vacuum-time=3d

# Follow and stream live systemd user journal logs in real-time
[group('Diagnostics')]
logs:
    @journalctl --user -e -f
