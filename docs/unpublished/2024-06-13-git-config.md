---
layout: post
title: 'My .gitconfig file disected'
date: 2024-06-13
author: Kiran Rao
---

This is my .gitconfig\*. Many are like it, but this one is mine.

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
```

## What is .gitconfig

## User section

```sh
[user]
	name = Kiran Rao
	email = hi@kiranrao.ca
```

The user section is straightforward. It's my name and email. But where is it actually used?

The user's name and email gets included to every commit and tag. This is clearly visible using `git log`. Running `git log` right now shows:

```sh
commit ce97934132deb2b322c54de68ccbc1d402ca18e4 (HEAD -> git-config)
Author: Kiran Rao <hi@kiranrao.ca>
Date:   Fri Jun 14 20:31:03 2024 -0400

    WIP: User section
```

This also yields a useful insight: It's easy to change my name and email per repo. Separate work and personal, or multiple clients is a good use case.

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
GPG attaches a signature to evey commit. We can see this with `git log --show-signature`:

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

Git aliases allow me to quickly run longer, complex git commands with fewer keystrokes. I've aliased common commands to be a little faster.

## Pretty commit history

```sh
	hist = log --graph --abbrev-commit --decorate --date=short \
		--branches --remotes --tags
		--format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(bold yellow)%d%C(reset)' \
```

An under rated feature of git is `git log`. While a normal `git log` will show a linear history, it can be configured to show way more.

- `--graph`: Shows
- `--abbrev-commit`: Shortens commit length
- `--decorate`: Short for `--derocate:sort`. `refs/` prefix will be ommitted
- `--date=shot`: Shortens date
- `--branches`: Shows all branches, not just the curent branch.
- `--remotes`: Shows the local copy of all remote barnches.
- `--tags`: Shows tags
- `--format=format:'...'` Applies a fancy format that I copied from somewhere years ago. `--oneline` is equivalent (but doesn't look as good)

Put it all together and it looks something like:

<img class="diagram" src="/assets/gitconfig-hist.png" alt="terminal screenshot of the alias git hist " width="50%" >

## Time-saving aliases

```sh
	git = !exec git
	gti = !exec git
```

## Conclusion

\*This is not actually my .gitignore. It's pretty close. I've rearranged and ommited a few pieces for clarity.
