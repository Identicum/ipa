# ipa
Identity-aware proxy based on Apache HTTP Server, mod_proxy and [mod_auth_oidc](https://github.com/zmartzone/mod_auth_openidc).

## Certificates
Issue as many certificates as necessary to be used in your reverse proxy.
IPA supports [wildcard certificates](https://en.wikipedia.org/wiki/Wildcard_certificate) and [SNI](https://en.wikipedia.org/wiki/Server_Name_Indication).

### Self-signed certificate
To test using a self-signed certificate, run the following command (replace with your domain):
```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout wildcard_identicum_com.key -out wildcard_identicum_com.cer
```

    Country Name (2 letter code) [XX]: `AR`
    State or Province Name (full name) []: `CABA`
    Locality Name (eg, city) [Default City]: `Buenos Aires`
    Organization Name (eg, company) [Default Company Ltd]: `Identicum`
    Organizational Unit Name (eg, section) []: ` `
    Common Name (eg, your name or your server hostname) []: `*.identicum.com`
    Email Address []: `no-reply@identicum.com`

Put the generated certificate files into your local `conf` directory.
When using a self-signed certificate, you have to comment-out the `SSLCACertificateFile` directive in the conf files.

## IDP
Create an OpenID Connect Client in your IDP using the following information:
- Client Name: IPA
- Client Description: IPA
- Scopes: profile, openid, email, user_name
- Response Types: code, id_token
- Grant Types: authorization_code
- Pre-Authorization: enabled
- Authentication method for the token endpoint: client_secret_basic

## Local configuration
Samples are provided in the [conf.samples](./conf.samples/) folder.

### default-vhost
Copy [template](./conf.samples/01_default-vhost.conf) into your local `conf` folder and customize parameters for hostnames and certificate files.

### mod_auth_openidc
Copy [template](./conf.samples/02_mod_auth_openidc.conf) into your local `conf` folder and customize parameters:
- OIDCProviderMetadataURL
- OIDCClientID
- OIDCClientSecret
- OIDCCryptoPassphrase

Use rest of the templates to create as many proxy definitions as you need, based on the samples.

## Run the container

Run the image, mounting local directories for configuration and certificates:

    docker run  -d \
        -p 80:80 \
        -p 443:443 \
        -v $(pwd)/conf/:/etc/httpd/conf.ipa/:ro \
        -v $(pwd)/certs/:/etc/httpd/certs/:ro \
        identicum/ipa:latest
