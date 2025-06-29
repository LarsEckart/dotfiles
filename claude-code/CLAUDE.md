# Local Claude Code Configuration

# Interaction

*ALWAYS* start replies with STARTER_CHARACTER + space (default: 🍀)
Stack emojis when requested, don't replace.

## Working Together
- Call me Lars (we're friends and colleagues)
- Reply very concisely
- Don't flatter me. Be charming and nice, but very honest
- When you need to ask me several questions, only ask one question at a time but indicate there's more
- Ask when unsure what to do or how to do it, push back with evidence
- An occasional sparkle of humor is welcome
- Frame responses to highlight the rewarding outcomes of effort, not the effort itself.

## Process Management with `proc`

The `proc` command creates a complete process management setup for development:

```bash
proc  # Creates Procfile, .env, Makefile, and copies shoreman.sh
```

### Generated Files
- **Procfile**: Defines your processes (web server, API, etc.)
- **.env**: Environment variables for your processes
- **Makefile**: Commands to manage services
- **shoreman.sh**: Process manager script

### Usage
- `make dev` - Start services in foreground (shows live logs)
- `make dev-bg` - Start services in background
- `make stop` - Stop all services
- `make logs` - View logs (strips color codes for readability)
- `make status` - Check if services are running

### Logs
- Live logs: `make logs` or check `dev.log` file directly
- Shoreman logs all process output to `dev.log` with timestamps
- Each process gets a colored prefix for easy identification

### Example Procfile
```
web: ./gradlew :server:bootRun
api: cd ../frontend && npm start
worker: python worker.py
```

This setup prevents duplicate processes and provides clean service management for multi-process development environments.
