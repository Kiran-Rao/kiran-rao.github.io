---
layout: post
title: 'My .gitconfig file disected'
date: 2024-06-13
author: Kiran Rao
---

This is my .gitconfig[^1]. Many are like it, but this one is mine.

It's not long. It's not complicated. But it configures my workflow's most important tool. I will disect the file to better understand my configurations and discover how git works.

```sh
[user]
	name = Kiran Rao
	email = hi@kiranrao.ca
	signingkey = AAAAABBBBBB

[gpg]
	program = gpg

[commit]
	gpgsign = true

[alias]
	co = checkout
	ci = commit
	st = status
	br = branch
	di = diff
	fp = fetch --prune
	rb = rebase
	hist = log --graph --abbrev-commit --decorate --date=short \
		--format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(bold yellow)%d%C(reset)' \
		--branches --remotes --tags
	git = !exec git
	gti = !exec git

[push]
	autoSetupRemote = true
```

## What is .gitconfig

A `.gitconfig` is a file that configures `git`. Duh.

It is a set of files that tells git how to operate. On UNIX-like systems, the user's config is located at `~/.gitconfig`. This file gets appended when running `git config --global ...`. If you omit `--global`, it writes to the repo at `.git/config`. There's also an even higher `--system` arguent. Don't use `--system`.

This article disects my user's git config. However, the leanings apply at all levels.

## User section

```sh
[user]
	name = Kiran Rao
	email = hi@kiranrao.ca
```

The user section is straightforward. It's my name and email. But where is it actually used?

The user's name and email gets included to every commit and tag. This is clearly visible by running `git log`:

```sh
commit ce97934132deb2b322c54de68ccbc1d402ca18e4 (HEAD -> git-config)
Author: Kiran Rao <hi@kiranrao.ca>
Date:   Fri Jun 14 20:31:03 2024 -0400

    WIP: User section
```

The user section also yields a useful insight: It's easy to change my name and email per repo. Separate work and personal, or multiple clients is a good use case.

It also leads to another insight: Nothing stops me from changing my user name and email to anything.
Nothing stops anyone from changing their name and email to mine.
Luckly we have GPG to mitigate that.

## GPG key signing

```sh
	signingkey = AAAAABBBBBB

[gpg]
	program = gpg

[commit]
	gpgsign = true
```

GPG is a public-key cryptography system used to sign commits. It ensures commits published were made by me (or someone with my private key or access to my github account).
GPG attaches a signature to evey commit. We can see the signature with `git log --show-signature`:

```sh
commit da7c2d3863581f00d489c0852a91bc15ba98eae0 (HEAD -> git-config)
gpg: Signature made Fri Jun 14 21:00:11 2024 EDT
gpg:                using EDDSA key BA8B30A6D0E47B0B447FD15DC0B595B4F1573243
gpg: Good signature from "Tigger 2024-06-11 <hi@kiranrao.ca>" [ultimate]
Author: Kiran Rao <hi@kiranrao.ca>
Date:   Fri Jun 14 21:00:11 2024 -0400

    Start GPG
```

Commits also appear "verified" in github, gitlab or your preferred git platform.

<img class="diagram" src="/assets/gitconfig-verified.png" alt="github screenshot showing unverified and verified commit " width="50%" >

I cannot go in-depth into how GPG signing works. [How (and why) to sign Git commits](https://withblue.ink/2020/05/17/how-and-why-to-sign-git-commits.html){:target="\_blank"} is an excellent article on the topic. For a practical guide on setting up GPG for a github account, [Generating a new GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key){:target="\_blank"} and [Adding a GPG key to your GitHub account](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account){:target="\_blank"}

## Alias common actions

```sh
[alias]
	co = checkout
	ci = commit
	st = status
	br = branch
	di = diff
	fp = fetch --prune
	rb = rebase
```

Git aliases let me to run commands with fewer keystrokes. I've aliased common commands to be slightly faster.

## Pretty commit history

I've aliased commands too long to write comfortably. `git hist` uses `git log` to show a project's commit graph.

```sh
	hist = log --graph --abbrev-commit --decorate --date=short \
		--branches --remotes --tags
		--format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(bold yellow)%d%C(reset)' \
```

While a normal `git log` will show a linear history, it can be configured to show way more.

- `--graph`: Graphs `*--*--*` beside each commit, showing how they relate to eachother.
- `--abbrev-commit`: Shortens commit length
- `--decorate`: Short for `--derocate:sort`. `refs/` prefix will be ommitted
- `--date=shot`: Shortens date
- `--branches`: Shows all branches, not just the curent branch.
- `--remotes`: Shows the local copy of all remote barnches.
- `--tags`: Shows tags
- `--format=format:'...'` Applies a fancy format that I copied from somewhere years ago. `--oneline` is equivalent (but doesn't look as good)

Put it together and I get a good view of my project's commit graph:

<img class="diagram" src="/assets/gitconfig-hist.png" alt="terminal screenshot of the alias git hist showing the commit graph" width="50%" >

`git hist` was especially useful as a new git user.
I could quickly see the commit graph after a merge, rebase or cherry-pick operation.
It's also an indespenible tool when debugging failed operations.
I can see the exact state of each branch in the repo.

## Time-saving aliases

```sh
	git = !exec git
	gti = !exec git
```

I've mindlessly typed `git git status` far too many times.
One approach is to punish the behavior.
"I should train myself to be better at typing so that I don't make this mistake".

I disagee. I don't want to be punished.
Avoiding `git git` doesn't improve the structure of my thinking. So I've smoothed over that papercut.
The `!exec` command executes a terminal command.
In this case running `git` again with all the same arguments. It's also recursive!

[gti](https://www.cyberciti.biz/linux-news/linux-unix-desktop-fun-gti-get-jeep-car-when-you-mistype-git/) is good fun, but an example of punishing the user for mistyping `gti` instead of `git`.

## Auto setup remote

```sh
[push]
	autoSetupRemote = true
```

This is another time saver. If I create and push a branch, I'll often run into the error:

```sh
fatal: The current branch new-branch has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin new-branch
```

This is dumb. If a branch doesn't have an upsteam branch, I always want to create one.
Setting `autoSetupRemote = true` automatically creates an upstream banch without having to use special args.
I'll never encounter this error again.

## Conclusion

[^1]: This is not actually my .gitignore. It's pretty close. I've rearranged and ommited a few pieces for privacy and clarity.
