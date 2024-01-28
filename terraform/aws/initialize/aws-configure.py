#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""This script configures ~/.aws/credentials based on existing environment variables."""
import os
import configparser
import sys
from pathlib import Path

profile = os.getenv("AWS_PROFILE", "")
aws_access_key_id = os.getenv("AWS_ACCESS_KEY_ID", "")
aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY", "")


def check_env_vars():
    ok = True

    if not profile:
        print("ERROR: env var AWS_PROFILE not defined")
        ok = False

    if not aws_access_key_id:
        print("ERROR: env var AWS_ACCESS_KEY_ID not defined")
        ok = False

    if not aws_secret_access_key:
        print("ERROR: env var AWS_SECRET_ACCESS_KEY not defined")
        ok = False

    if not ok:
        sys.exit(1)


def write_credentials():
    assert profile and aws_access_key_id and aws_access_key_id

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


def main():
    check_env_vars()
    write_credentials()


if __name__ == "__main__":
    main()
