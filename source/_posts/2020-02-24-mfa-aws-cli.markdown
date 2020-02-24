---
layout: post
title: Masuk dengan MFA pada antarmuka AWS CLI
date: 2020-02-24 05:28
comments: true
categories:
lang: id
---

MFA (multi-factor authentication) menawarkan mekanisme login yang lebih aman.
Pada AWS, kita bisa memaksa setiap pengguna agar menghidupkan MFA. Setiap kali
kita login, kita akan ditanya token untuk MFA. MFA yang cukup lazim adalah
menggunakan TOTP seperti Google Authenticator atau Authy.

Pada kasus kali ini, saya mengasumsikan setiap akun IAM memiliki akses yang
terbatas (hanya read). Jika akun pengguna tersebut mau melakukan akses
tulis, mereka harus melakukan Switch Role.

Berikut adalah script yang bisa digunakan untuk switch role melalui MFA

    # Ganti ini ke ARN perangkat Anda
    export DEVICE_ARN="arn:aws:iam::054121719833:mfa/mufid"
    
    read -p "Enter token from MFA(from $DEVICE_ARN): " TOKEN
    RESULT=$(aws sts get-session-token --serial-number $DEVICE_ARN --token-code $TOKEN)
    export AWS_SECRET_ACCESS_KEY=$(echo "$RESULT" | yq -r '.Credentials.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo "$RESULT" | yq -r '.Credentials.SessionToken')
    export AWS_ACCESS_KEY_ID=$(echo "$RESULT" | yq -r '.Credentials.AccessKeyId')

    echo "SecretAccessKey = $AWS_SECRET_ACCESS_KEY"
    echo "SessionToken = $AWS_SESSION_TOKEN"
    echo "AccessKeyId = $AWS_ACCESS_KEY_ID"

    aws configure set profile.mfa.aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set profile.mfa.aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set profile.mfa.aws_session_token "$AWS_SESSION_TOKEN"

    echo "Selesai! Lakukan perintah ini untuk mengakses role baru"
    echo
    echo "         export AWS_PROFILE=secureadmin"
    echo
