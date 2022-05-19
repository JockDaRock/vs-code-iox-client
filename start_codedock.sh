#!/bin/bash

nohup dockerd &
code-server --bind-addr=0.0.0.0:8080