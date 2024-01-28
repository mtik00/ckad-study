#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

POSITIONAL_ARGS=()
CREATE=0
DELETE=0
AWS=0

# NOTE: These must match the TF backend config
S3_BUCKET=${TF_STATE_BUCKET:-acg-mtik00-bucket-02}
DYNAMODB_TABLE=${TF_STATE_TABLE:-act-mtik00-tf-state}

PROFILE=${AWS_PROFILE:-cloudguru}

USAGE=$(cat <<EOF
Usage:
    $(basename "") <args>

    Arguments:
        -c|--create  : Create the bucket and table (if needed)
        -d|--delete  : Delete the bucket and table (if needed)
        -a|--aws     : Write the access key to aws credentials
        -h|--help    : Show this message
EOF
)

function usage() {
    printf "%s\n" "${USAGE}"
    exit 99
}


function argparse() {
    while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--aws)
            AWS=1
            shift
            ;;
        -c|--create)
            CREATE=1
            shift
            ;;
        -d|--delete)
            DELETE=1
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Unknown option: '$1'"
            usage
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift
            ;;
    esac
    done
}


function configure_aws() {
    local f="${SCRIPT_DIR}/aws-configure.py"
    /usr/bin/env python "${f}"
}

function create() {
    if [[ ! `aws --profile ${PROFILE} s3 ls | grep ${S3_BUCKET}` ]]; then
        echo "creating bucket"
        \aws --profile ${PROFILE} s3api create-bucket --bucket ${S3_BUCKET} --region ${AWS_DEFAULT_REGION}
    fi

    if [[ ! `aws --profile ${PROFILE} dynamodb list-tables | grep ${DYNAMODB_TABLE}` ]]; then
        echo "creating table"
        \aws --profile ${PROFILE} dynamodb create-table \
            --table-name ${DYNAMODB_TABLE} \
            --attribute-definitions AttributeName=LockID,AttributeType=S \
            --key-schema AttributeName=LockID,KeyType=HASH \
            --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
            --region ${AWS_DEFAULT_REGION}
    else
        echo "DynamoDB table already created"
    fi
}

function delete() {
    if [[ `\aws --profile ${PROFILE} s3 ls | grep ${S3_BUCKET}` ]]; then
        echo "deleting bucket"
        \aws --profile ${PROFILE} s3api delete-bucket --bucket ${S3_BUCKET} --region ${AWS_DEFAULT_REGION}
    else
        echo "bucket not found"
    fi

    if [[ `\aws --profile ${PROFILE} dynamodb list-tables | grep ${DYNAMODB_TABLE}` ]]; then
        echo "deleting table"
        \aws --profile ${PROFILE} dynamodb delete-table \
            --table-name ${DYNAMODB_TABLE} \
            --region ${AWS_DEFAULT_REGION}
    else
        echo "DynamoDB table not found"
    fi
}

function validate_args() {
    local error=0

    if [[ "${CREATE}${DELETE}${AWS}" == "000" ]] || [[ "${CREATE}${DELETE}" == "11" ]]; then
        echo "Must select either --create or --delete"
        error=1
    fi

    if [[ $error -gt 0 ]]; then
        usage
        exit 1
    fi
}


function main() {
    argparse "$@"
    validate_args

    if [[ $AWS -eq 1 ]]; then
        configure_aws
    fi

    if [[ $CREATE -eq 1 ]]; then
        create
    elif [[ $DELETE -eq 1 ]]; then
        delete
    fi
}


main "$@"
