---
layout: post
title: 'Stop saying false positive'
subtitle: "Stop saying false positive or false negative. Describe what's happening instead"
date: 2026-11-23
author: Kiran Rao
---

Stop saying "false positive" or "false negative". It's confusing and hard to understand. Instead, replace them with a description of what's happening. For example:

- What's the gps reciever false positive rate? -> What's the gps reciever false lock rate?
- It would be really bad if this fire alarm has false negatives -> It would be really bad if this fire alarm fails to detect a fire.
- We rolled out a new DKIM lookup for our spam detector. Unfortunately it has a lot of false positives. -> Unfortunately it has a lot of rejections.

## Why

**It can be unclear.** The sentence fragment "gps reciever false positive rate" could mean a lot of different things. A "false lock rate" is far more clear.

**It's prone to double negatives and hard to understand.** The sentence fragment "fire alarm has false negatives" requires me to figure out that "negative" means not detecting a fire. Then false negative means not detecting a fire that exists. "fire alarm fails to detect a fire" is much more clear.

**It can be misleading.** False positives in "DKIM lookup for our spam detector" could be referring to "DKIM lookup" or "spam detection". A positive lookup and a postiive spam detection mean the opposite thing. "false rejections" is unambiguous for both DKIM and spam detection.

## Type I and Type II Error

Using Type I and Type II Error is even worse. No one remembers which is which without looking it up. Even if you do, the person you're talking to probably doesn't. Even if everyone remembers, it's still unclear for all the reasons above. Lets all stop using these terms.
