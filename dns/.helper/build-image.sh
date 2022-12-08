#!/usr/bin/env bash
# -*- coding: utf-8 -*-

buildFrom=ghcr.io/home-assistant/amd64-base-debian:bullseye
buildVersion=10.0.1
imageName=x-breitschaft/"$(basename "$PWD")"
docker build --build-arg BUILD_FROM="${buildFrom}" --build-arg BUILD_VERSION="${buildVersion}" --tag "${imageName}:latest" --tag "${imageName}":"${buildVersion}"  .
