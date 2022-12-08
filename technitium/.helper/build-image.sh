#!/usr/bin/env bash
# -*- coding: utf-8 -*-

imageName=x-breitschaft/"$(basename "$PWD")"
docker build -t "${imageName}" .
