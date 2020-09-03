# bitwarden-kubernetes

A kustomize manifest used to deploy bitwarden on kubernetes

## Configuration

You need to copy the `.env` file to create your own

```bash
cp .env prod.env
```

Then using your favorite editor (`vim` for sure :P) modify the file to setup your own configuration

### Changing namespace

Edit the line `namespace: bitwarden` in the `kustomize.yml` file

## Usage

1. Intialize/generate token, key and certificate, pick the same environement that the name you used for the file.

For example, I create a `prod.env` file so my environement will be `prod`

```bash
./setup init prod
```

2. Create the namespace and install bitwarden

```bash
./setup install prod
```

3. Apply new modification

```bash
./setup apply prod
```

4. Delete the namespace and all its content

```bash
./setup delete prod
```

## Upgrading bitwarden

Just change the version in the kustomize.yml file and apply once again.

## Knowing issues

Bitwarden is curently not fully compatible with kubernetes, beacause some services are not cloud native.

### SSO is not curently available

I didn't work on the sso part yet

### Upgrading bitwarden

There is currently no way to upgrade bitwarden with this setup

### Service running at root

All of them

### Folder normally sharing the same folder

* admin
* api
* attachments
* identity
