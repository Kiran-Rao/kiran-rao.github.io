---
layout: post
title: 'My .gitconfig file disected'
date: 2024-06-13
author: Kiran Rao
---

This is my .gitconfig. Many are like it, but this one is mine.

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

It also leads to another insight: Nothing stops me from changing my user name and email to anything. Nothing stops anyone from changing their name and email to mine. Luckly we have a system to stop that.

## GPG key signing

```sh
	signingkey = AAAAABBBBBB

[gpg]
	program = gpg

[commit]
	gpgsign = true
```

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

## Pretty commit history

```sh
	hist = log --graph --abbrev-commit --decorate --date=short \
		--format=format:'%C(bold cyan)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset) %C(bold yellow)%d%C(reset)' \
		--branches --remotes --tags
```

## Time-saving typos

```sh
	git = !exec git
	gti = !exec git
```
