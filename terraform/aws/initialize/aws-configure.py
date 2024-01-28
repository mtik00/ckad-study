#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import configparser
from pathlib import Path

profile = os.environ["AWS_PROFILE"]
aws_access_key_id = os.environ["AWS_ACCESS_KEY_ID"]
aws_secret_access_key = os.environ["AWS_SECRET_ACCESS_KEY"]

credentials = Path("~/.aws/credentials").expanduser()
if not credentials.exists():
    credentials.touch()
    credentials.chmod(0o600)

config = configparser.ConfigParser()
config.read(credentials)
config[profile] = {
    "aws_access_key_id": aws_access_key_id,
    "aws_secret_access_key": aws_secret_access_key,
}

config.write(credentials.open("w"))
print("Credentials writted to:", str(credentials))
