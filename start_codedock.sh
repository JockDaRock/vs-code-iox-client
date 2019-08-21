#!/bin/bash

nohup dockerd &
code-server --allow-http --no-auth