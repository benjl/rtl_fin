#!/bin/bash
docker build --target builder -t osplo/rtl_fin:builder .
docker build -t osplo/rtl_fin:latest .