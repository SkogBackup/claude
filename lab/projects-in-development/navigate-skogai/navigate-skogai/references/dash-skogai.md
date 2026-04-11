<name_explanation>

**dash-skogai** is the file-safe name for `/skogai`

the dash comes from the un-usual path choice of `/skogai` - being that it is directly off the root `/` rather than in a subdirectory. this is not by accident, but a deliberate choice to signify the folders special permissions and usage within the SkogAI ecosystem.

dash-skogai, or `/skogai`, is named this way to denote its system-wide reach, accessible to certain users on the machine. this placement indicates that the contents of `/skogai` are intended to be shared resources, configurations, or tools that are not user-specific but rather system-wide.

</name_explanation>

<multi_agent_architecture>

`/skogai` is owned by user `skogix` and group `skogai` with setgid permissions (`drwxrwsr-x`). The `skogai` group includes both human users (skogix, aldervall) and AI agents as system users (dot, amy, claude, goose). The setgid bit ensures files created by any member automatically inherit `skogai` group ownership, enabling seamless multi-agent collaboration without manual permission management.

</multi_agent_architecture>
