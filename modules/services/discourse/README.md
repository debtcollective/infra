# Description:

Discourse module creates a EC2 instance with Discourse.

## Setup steps

In order to enable some features in Discourse, we need to do some manual
configuration.

### Enable S3 Uploads and Backups

1. Create an IAM user (ex. `community-staging`). Remember save the credentials
2. Add the following IAM policy to this user

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::community-uploads-staging",
        "arn:aws:s3:::community-uploads-staging/*"
      ]
    }
  ]
}
```

3. Create buckets for uploads with the same name as in the policy (ex. community-uploads-staging)
4. Enable S3 uploads in the discourse admin, [follow this guide](https://meta.discourse.org/t/setting-up-file-and-image-uploads-to-s3/7229)

### Enable Reply via Email

Refer to this [guide](https://meta.discourse.org/t/set-up-reply-via-email-support-e-mail/14003).

In our case, the debtcollective.org google apps configuration is set to require two factor authentication for all accounts, we need to enable that for our replies email and create an [App Password](https://support.google.com/accounts/answer/185833?hl=en) for POP to work.

### Set Discourse as SSO provider

Refer to this [guide](https://meta.discourse.org/t/using-discourse-as-a-sso-provider/32974)
