# tghs/cli

**Purpose**: Serve as a base image for cli tools. May also be used on its own
to get a shell.

This image is for a project which requires that it's possible to mount a volume without meesing up file permissions. Making this work on both Linux and OSX is not straight forward at all.

This image is used as a base because it includes a fix that several images also uses. The fix/hack is to create a user, and have a script to run as entrypoint, which modifies the UID and GID to match the mounted folder UID and GID. This makes the user privileged, which is required on OSX to be able to modify mounted volumes, but won't mess up permissions on linux.

If you override `--entrypoint`, no modification of the user is made, and you will not be able to work on mounted volumes from OSX, unless you do some other kind of magic.

The user doesn't really need a $HOME, but bower refuses to run without it. One of our other docker containers runs bower so that's why we create a home directory for our user.

## VOLUMES
You can mount volumes into the `/data` directory.

I.e.
``docker run -it -v `pwd`/myData:/data tghs/cli
``

## Setting UID and GID

Give docker the variables `USER_ID` and `GROUP_ID`.

With `docker`:

```
docker run -it -v `pwd`/mydata:/data -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) tghs/cli
```

With `docker-compose`:

```
services:
    cli:
        image: tghs/cli
        volume: ./mydata:/data
        environment:
            - USER_ID=123
            - GROUP_ID=456
```

No, we can't use simple variable subtitutions here. We have a script that fills this in with `envsubst`.
