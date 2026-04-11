---
name: fakechat is reference only
description: fakechat is an example template for how MCP channel protocol works — never build upon it or modify it
type: feedback
---

fakechat is ONLY an example template, not something to build upon or extend. It demonstrates the MCP channel protocol pattern (deliver/reply) but the actual implementation should be a generic chat-io contract.

**Why:** User clarified during Phase 5 discuss-phase that fakechat is reference material. The research doc was entirely fakechat-specific, which led to plans that assumed building on fakechat. This correction redirected Phase 5 to a two-layer architecture: generic contract + transport-specific implementations.

**How to apply:** When working on chat/channel features, build generic abstractions first. Reference fakechat's server.ts for protocol understanding but never create plans that modify lab/fakechat/. The contract is: deliver() for inbound, reply for outbound — transport-agnostic.
