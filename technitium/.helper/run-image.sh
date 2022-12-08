#!/usr/bin/env bash
# -*- coding: utf-8 -*-

imageName=x-breitschaft/"$(basename "$PWD")":latest
docker run -d --rm -p 5380:5380 "${imageName}"
