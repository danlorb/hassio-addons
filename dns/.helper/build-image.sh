#!/usr/bin/env bash
# -*- coding: utf-8 -*-

buildFrom=ghcr.io/home-assistant/amd64-base-debian:bullseye
imageName=x-breitschaft/"$(basename "$PWD")"
docker build --build-arg BUILD_FROM="${buildFrom}" --tag "${imageName}:latest" .
