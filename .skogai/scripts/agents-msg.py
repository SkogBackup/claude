#!/usr/bin/env python3
"""Inter-agent messaging over SSH.

Simple file-based messaging between agents running on different VMs.
Messages are YAML files transferred via SCP.

Usage:
    # Send a message to Alice
    python3 scripts/agent-msg.py send alice "Subject" "Message body"

    # List unread messages
    python3 scripts/agent-msg.py list

    # Send to all agents
    python3 scripts/agent-msg.py broadcast "Subject" "Message body"

    # Check connectivity
    python3 scripts/agent-msg.py status

Configuration:
    Agent registry is loaded from messages/agents.yaml in the workspace root.
    Example agents.yaml:

        bob:
          ssh: bob@bob.example.com
          workspace: /home/bob/bob
        alice:
          ssh: alice@alice.example.com
          workspace: /home/alice/alice

