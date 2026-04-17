---
title: zellij
type: note
permalink: claude/lab/projects-in-development/zellij/zellij
---

# [Introduction](3D=){.3D"header" "https:="" zellij.dev="" documentation="" print.html#introduction"=""}= {#3D"introduction"}

This is the documentation for the Zellij terminal workspace.

- For installing Zellij, see: [Installation](3D%22https://zellij.dev/documentation=){installation.html"=""}
- For configuring Zellij, see: [Configuration](3D%22https://zellij.dev/documentatio=){n="" configuration.html"=""}
- For Operating System Compatibility and Known Issues, see: [Compatibility](3D%22ht=){tps:="" zellij.dev="" documentation="" compatibility.html"=""}
- For setting up layouts: [Layouts](3D%22https://zellij.dev/documentation/lay=){outs.html"=""}
- For developing plugins: [Plugins](3D%22https://zellij.dev/documentation/plu=){gins.html"=""}

You can also check out some [S= creencasts & Tutorials](3D%22https://zellij.dev/screencasts%22) about using Zellij.

**Looking for the docs for versions `<0.32.= 0`{.3D"hljs"}? [Look no further!=](3D%22https://zellij.dev/old-documentation%22)**

::: {style="3D"break-before:" page;="" page-break-before:="" always;"=""} :::

# [Installation](3D%22https://zellij.dev/documentat=){.3D"header" ion="" print.html#installation"=""} {#=3D"installation"}

The easiest way to install Zellij is through [a package for = your OS](3D%22https://zellij.d=){ev="" documentation="" installation.html#third-party-repositories"=""}.

If one is not available for your OS, you can [download a prebuilt bin= ary](3D%22https://zellij.d=){ev="" documentation="" installation.html#binary-download"=""} or even [try Zellij without installi= ng](3D%22https://zellij.dev/%22).

If you have Cargo installed, you can download the latest release using \<= a href=3D"https://zellij.dev/documentation/installation.html#cargo-binstall= ">cargo binstall.

Otherwise, you can [compile and install it with Cargo](3D%22https://zellij.dev/documentation/installat=){ion.html#rust-cargo"=""}.

______________________________________________________________________

## [Rust - Cargo](3D%22https://zellij.dev/docu=){.3D"header" mentation="" print.html#rust---cargo"=""} {#3D"rust---cargo"}

For instructions on how to install Cargo see [here](3D%22https://doc.rust=){-lang.org="" cargo="" getting-started="" installation.html"=""}.

Once installed run:

```
cargo install --locked zellij
```

If experiencing errors, if installed through rustup, please try running:=

```
rustup update
```

______________________________________________________________________

## [Cargo - binstall](3D%22https://zellij.dev/=){.3D"header" documentation="" print.html#cargo---binstall"=""} {#3D"cargo---binstall"}

For smaller machines like laptops, you might want to just install the bi= nary instead of compiling everything.

The easiest way if cargo is present, is to install with the [binstall cargo extension](3D%22h=){ttps:="" crates.io="" crates="" cargo-binstall"=""}:

```
cargo binstall zellij
```

______________________________________________________________________

## [Binary Download](3D%22https://zellij.dev/d=){.3D"header" ocumentation="" print.html#binary-download"=""} {#3D"binary-download"}

Binaries are made available each release for the Linux and MacOS operati= ng systems.

It is possible to download the binaries for these on the [release](3D%22http=){s:="" github.com="" zellij-org="" zellij="" releases"=""} page.

Once downloaded, untar the file:

```
tar -xvf zellij*.tar.gz
```

check for the execution bit:

```
chmod +x zellij
```

and then execute Zellij:

```
./zellij
```

Include the directory Zellij is in, in your [PATH Variable](3D%22https://www.baeld=){ung.com="" linux="" path-variable"=""} if you wish to be able to ex= ecute it anywhere.

'Or'

move Zellij to a directory already included in your [$PATH] Variable.

______________________________________________________________________

## [Compilin= g Zellij From Source](3D%22https:/=){.3D"header" zellij.dev="" documentation="" print.html#compiling-zellij-from-source"=""} {#3D"compiling-zellij-from-source"}

Instructions on how to compile Zellij from source can be found

here.

## [Third party repo= sitories](3D%22https://zel=){.3D"header" lij.dev="" documentation="" print.html#third-party-repositories"=""} {#3D"third-party-repositories"}

Zellij is packaged in some third part repositories. Please keep in mind that they are not directly affiliated with zellij maint= ainers:

[![3DPackaging](3D%22htt=){ps:="" repology.org="" badge="" vertical-allrepos="" zellij.svg"="" stat="us""}](3D%22https://repology.org/project/zellij/versions%22)

More information about third party installation can be found [here](3D%22=){https:="" github.com="" zellij-org="" zellij="" blob="" main="" docs="" third_party_install.md"=""}.

::: {style="3D"break-before:" page;="" page-break-before:="" always;"=""} :::

# [Integration](3D%22https://zellij.dev/documentati=){.3D"header" on="" print.html#integration"=""} {#=3D"integration"}

Zellij provides some environment variables, that make Integration with existing tools possible.

```
echo $ZELLIJ
echo $ZELLIJ_SESSION_NAME
```

The `ZELLIJ_SESSION_NAME`{.3D"hljs"} has the session name= as its value, and `ZELLIJ`{.3D"hljs"} gets set to `0`{.3D"hljs"} inside a zellij session. Arbitrary key value pairs can be set through configuration, or layouts. Note that `ZELLIJ_SESSION_NAME`{.3D"hljs"} will not be updat= ed for existing terminal panes when renaming a session (but will for new pa= nes).

Here are some limited examples to help get you started:

## [Autostart = on shell creation](3D%22https://=){.3D"header" zellij.dev="" documentation="" print.html#autostart-on-shell-creation"=""} {#3D"autostart-on-shell-creation"}

Autostart a new zellij shell, if not already inside one. Shell dependent, fish:

```
if set -q ZELLIJ
else
  zellij
end
```

other ways, zellij provides a pre-defined auto start scripts.

### [bash](3D%22https://zellij.dev/documentatio=){.3D"header" n="" print.html#bash"=""} {#3D"bash"}

```
echo 'eval "$(zellij setup --generate-aut=
o-start bash)"' >> ~/.bashrc
```

### [zsh](3D%22https://zellij.dev/documentation=){.3D"header" print.html#zsh"=""} {#3D"zsh"}

```
echo 'eval "$(zellij setup --generate-aut=
o-start zsh)"' >> ~/.zshrc
```

### [fish](3D%22https://zellij.dev/documentatio=){.3D"header" n="" print.html#fish"=""} {#3D"fish"}

=E2=9A=A0=EF=B8=8F Depending on the version of the `= fish`{.3D"hljs"} shell, the setting may not work. In that case, check out this \<= a href=3D"https://github.com/zellij-org/zellij/issues/1534">issue.

Add

```
if status is-interactive
    ...
    eval (zellij setup --generate-auto-start fish | string collect)
end
```

to `$HOME/.config/fish/config.fish`{.3D"hljs"} file.

The following environment variables can also be used in the provided scr= ipt.

::: 3D"table-wrapper" Variable Descrip= tion default

______________________________________________________________________

`ZELLIJ_AUTO_ATTACH`{.3D"hljs"} If the zelli= j session already exists, attach to the default session. (not starting as a= new session) false `ZELLIJ_AUTO_EXIT`{.3D"hljs"} When zellij ex= its, the shell exits as well. false :::

List current sessions\<= /a>

List current sessions, attach to a running session, or create a new one. Depends on [`sk`{.3D"hljs= "=""}](3D%22https://github.com/lotabout/skim%22) & `bash`{.3D"hljs"}

```
#!/usr/bin/env bash
ZJ_SESSIONS=3D$(zellij list-sessions)
NO_SESSIONS=3D$(echo "${ZJ_SESSIONS}" | wc -l)

if [ "${NO_SESSIONS}" -ge 2 ]; then
    zellij attach \
    "$(echo "${ZJ_SESSIONS}" | sk)"
else
   zellij attach -c
fi
```

## [List layout files and create a layout](=3D%22https://zellij.dev/documentation/print.html#list-layout-files-and-creat=){.3D"header" e-a-layout"=""} {#3D"list-layout-files-and-create-a-layout"}

List layout files saved in the default layout directory, opens the selected layout file. Depends on: `tr`{.3D"hljs"}, `fd`{.3D"hljs"},= `sed`{.3D"hljs"}, `sk`{.3D"hljs"}, `grep`{cla="ss=3D"hljs""} & `bash`{.3D"hljs"}

```
#!/usr/bin/env bash
set -euo pipefail
ZJ_LAYOUT_DIR=3D$(zellij setup --check \
    | grep "LAYOUT DIR" - \
    | grep -o '".*"' - | tr -d '"')

if [[ -d "${ZJ_LAYOUT_DIR}" ]];then
        ZJ_LAYOUT=3D"$(fd --type file . "${ZJ_LAYOUT_DIR}" \
        | sed 's|.*/||' \
        | sk \
        || exit)"
    zellij --layout "${ZJ_LAYOUT}"
fi
```

::: {style="3D"break-before:" page;="" page-break-before:="" always;"=""} :::

# [FAQ](3D%22https://zellij.dev/documentation/print=){.3D"header" .html#faq"=""} {#=3D"faq"}

## [Zellij overrides certain key combinations that I use= for other apps, what can I do?](3D%22https://zellij.dev/documentat=){.3D"header" ion="" print.html#zellij-overrides-certain-key-combinations-that-i-use-for-oth="er-apps-what-can-i-do""} {#3D"zellij-overrides-certain-key-combinations-that-i-use-for-other-ap= ps-what-can-i-do"=""}

The best and easiest way is to choose the "Unlock-First (non-colliding)"= [keybi= nding preset](3D%22https://zellij.dev/documentation/keybinding-presets.html%22). If that is not sufficient for your use case, you can also= [choos= e different modifiers](3D%22https://zellij.dev/documentation/changing-modifiers.html%22).

## [The UI takes up too much space,= what can I do about it?](3D%22https://zellij.dev/documentation/print.html#the-ui-take=){.=3D"header" s-up-too-much-space-what-can-i-do-about-it"=""} {#3D"the-ui-takes-up-too-much-space-what-can-i-do-about-it"}

You can load the `compact`{.3D"hljs"} layout with `zellij --layout compact`{c="lass=3D"hljs""}.

Additionally, you can disable pane frames either at runtime with `Ctrl + <p> + <z>`{c="lass=3D"hljs""} or through the [config](3D=){"https:="" zellij.dev="" documentation="" configuration.html"=""} with pane_frames: false.

### [Followup Question: can= I use the `compact` layout but still see the keybinding hints w= hen necessary?](3D%22https://zellij=){.3D"header" .dev="" documentation="" print.html#followup-question-can-i-use-the-compact-layou="t-but-still-see-the-keybinding-hints-when-necessary""} {#3D"followup-question-can-i-use-the-compact-layout-but-still-see-the-= keybinding-hints-when-necessary"=""}

Yes! You can set up a keybinding tooltip toggle for the compact-bar. Cho= ose a key (for example `F1`{.3D"hljs"}) and set it up in the= [config](3D%22https://zellij.dev/documentation/configuration.html%22)= (and then restart):

```
plugins {
    // ...
    // compact-bar location=3D"zellij:compact-=
bar" <=3D=3D COMMENT OUT THIS LINE
    // and replace it with the following:
    compact-bar location=3D"zellij:compact-bar"=
 {
      tooltip "F1"
    }
    // ...
}
```

## [I see broken charac= ters in the default UI, how can I fix this?](3D%22https://zellij.dev/documentation/print.html#i-see-=){.3D"header" =="" broken-characters-in-the-default-ui-how-can-i-fix-this"=""} {#3D"i-see-broken-characters-in-the-default-ui-how-can-i-fix-this"}

This means your default terminal font doesn't include some special chara= cters used by Zellij. A safe bet would be to install and use a font from nerdfonts.

If you don't want to install a new font, you can also load the simplifie= d UI that doesn't use these characters, with:

```
zellij options --simplified-ui true
```

## [I am a macOS user, how can I use the Alt key?](3D%22https://zellij.dev/documentation/print.html#i-am-a-macos-user-how-c=){.3D"header" =="" an-i-use-the-alt-key"=""} {#3D"i-am-a-macos-user-how-can-i-use-the-alt-key"}

This depends on which terminal emulator you're using. Here are some link= s that might be useful:

1. [iTerm2](3D%22https://www.reddit.com/r/zellij/comments/13twru4/comment/kpm=){sjv2="" ?utm_source="3Dshare&utm_medium=3Dweb3x&utm_name=3Dweb3xcss&=" ;utm_term="3D1&utm_content=3Dshare_button""}
1. [Terminal.app](3D%22https://superuser.com/questions/1038947/using-the-option-key=){-properly-on-mac-terminal"=""}
1. [Alacritty](3D%22https://github.com/zellij-org/zellij/issues/2051#issuecommen=){t-1461519892"=""}

## [Copy / Paste isn't working, how can I fix this?](3D%22https://zellij.dev/documentation/print.html#copy--paste-isnt-workin=){.3D"header" =="" g-how-can-i-fix-this"=""} {#3D"copy--paste-isnt-working-how-can-i-fix-this"}

Some terminals don't support the the OSC 52 signal, which is the method = Zellij uses by default to copy text to the clipboard. To get around this, y= ou can either switch to a supported terminal (eg. Alacritty or xterm) or co= nfigure Zellij to use an external utility when copy pasting (eg. xclip, wl-= copy or pbcopy).

To do the latter, add one of the following to your [Zellij Config](3D%22https://ze=){llij.dev="" documentation="" configuration.html"=""}:

```
copy_command: "xclip -selection clipboard=
" # x11
copy_command: "wl-copy"                    # wayland
copy_command: "pbcopy"                     # osx
```

Note that the only method that works when connecting to a remote Zellij = session (eg. through SSH) is OSC 52. If you require this functionality, ple= ase consider using a terminal that supports it.

## [How can = I use floating panes?](3D%22https:/=){.3D"header" zellij.dev="" documentation="" print.html#how-can-i-use-floating-panes"=""} {#3D"how-can-i-use-floating-panes"}

You can toggle showing/hiding floating panes with `C= trl + <p> + <w>`{.3D"hljs"} (if no floating panes are open, one will= be opened when they are shown).

In this mode you can create additional windows as you would normally cre= ate panes (eg. with `Alt + <n>`{.3D"hljs"}). Move them= with the mouse or the keyboard, and resize them as you would normally resi= ze or move Zellij panes.

You can also embed a floating pane with `Ctrl + <= p> + <e>`{.3D"hljs"}, and float an embedded pane in the same way.

## [How can I switch between sessions or launch a new session from= within Zellij?](3D%22https://zellij.dev/documentation/p=){.3D"header" rint.html#how-can-i-switch-between-sessions-or-launch-a-new-session-from-wi="thin-zellij""} {#3D"how-can-i-switch-between-sessions-or-launch-a-new-session-from-wi= thin-zellij"=""}

You can use the built-in `session-manager`{.3D"hljs"}. By= default, launch it with `Ctrl o`{.3D"hljs"} + `w`{.=3D"hljs"}.

## [E= diting the pane scrollbuffer with `ctrl + <s> + <e>`= doesn't work, what's wrong?](3D%22https://zellij.dev/documentation/print.ht=){.3D"header" ml#editing-the-pane-scrollbuffer-with-ctrl--s--e-doesnt-work-whats-wrong"=""} {#3D"editing-the-pane-scrollbuffer-with-ctrl--s--e-doesnt-work-whats-w= rong"=""}

By default, Zellij looks for an editor defined in the `EDITOR`{.3D"hlj= s"=""} or `VISUAL`{.3D"hljs"} environment variable= s (in this order). Make sure one is set (eg. `export EDITOR=3D/usr/bin/vim= `{.3D"hljs"}) before Zellij starts. Alternatively, you can set one in the Zellij [config](3D%22https://zellij.dev/=){documentation="" configuration.html"=""} using `scr= ollback-editor`{.3D"hljs"}.

::: {style="3D"break-before:" page;="" page-break-before:="" always;"=""} :::

# [Commands](3D%22https://zellij.dev/documentation/=){.3D"header" print.html#commands"=""} {#=3D"commands"}

These commands can be invoked with `zellij [SUBCOMMA= ND]`{.3D"hljs"}. For more details, each subcommand has its own help section when run with th= e `--help`{.3D"hljs"} flag (`zellij [SUBCO= MMAND] --help`{.3D"hljs"}).

## [`attach [session-name= ]`](3D%22https://zellij.d=){.3D"header" ev="" documentation="" print.html#attach-session-name"=""} {#3D"attach-session-name"}

short: `a`{.3D"hljs"}

Zellij will attempt to attach to an already running session, with the na= me `[session-name]`{.3D"hljs"}. If given no `[session-name]`{.3D"hljs"} and there is only on= e running session, it will attach to that session.

The attach subcommand will also accept the optional `options`{.3D"hljs"=} subcommand.

## [`list-sessions`](3D%22https://zellij.dev/doc=){.3D"header" umentation="" print.html#list-sessions"=""} {#3D"list-sessions"}

short: `ls`{.3D"hljs"}

Will list all the names of currently running sessions.

## [`ki= ll-sessions [target-session]`](3D%22https:/=){.3D"header" zellij.dev="" documentation="" print.html#kill-sessions-target-session"=""} {#3D"kill-sessions-target-session"}

short: `k`{.3D"hljs"}

Will kill the session with the name of `[target-sess= ion]`{.3D"hljs"}, if it is currently running.

## [`kill-all-sessions`=](3D%22https://zellij.dev=){.3D"header" documentation="" print.html#kill-all-sessions"=""} {#3D"kill-all-sessions"}

short: `ka`{.3D"hljs"}

Will prompt the user to kill all running sessions.

## [`options`](3D%22https://zellij.dev/documenta=){.3D"header" tion="" print.html#options"=""} {#3D"options"}

Can be used to change the behaviour of zellij on startup. Will supercede options defined in the config file. To see a list of options look [here](3D%22https://zellij.dev/documentation/c=){ommand-line-options.html"=""}.

## [`setup`](3D%22https://zellij.dev/documentati=){.3D"header" on="" print.html#setup"=""} {#3D"setup"}

Functionality to help with the setup of zellij.

::: 3D"table-wrapper" Flag :::
