# addons/borgbackups.sh for Centmin Mod 123.09beta01

Centmin Mod 123.09beta01 and newer version addon for [borgbackups](https://borgbackup.readthedocs.io/en/stable/index.html). By default non site directories are backed up for Centmin Mod LEMP stack server's environment directories that directly Centmin Mod as defined by space separated list of directories defined in `BORG_BACKUPTARGETS` variable. `addons/borgbackups.sh` uses zstd compression level 6 by default for creating borg backup repos.

```
BORG_BACKUPTARGETS='/root/.ssh /root/tools /root/centminlogs /usr/local/nginx/conf /usr/local/nginx/conf/conf.d /etc/centminmod'
```

You could add `/home/nginx/domains` to that list if you want to backup Nginx vhost domain sites too.

```
BORG_BACKUPTARGETS='/home/nginx/domains /root/.ssh /root/tools /root/centminlogs /usr/local/nginx/conf /usr/local/nginx/conf/conf.d /etc/centminmod'
```

## usage options

* install - install borgbackup yum package and setup and initialize the borg repository at `/home/borgbackups`
* backup - run borg backup to create repos for defined `BORG_BACKUPTARGETS` space separated list of directories
* cleanup - wipes and removes all borg backup config and repos

```
Usage:

./borgbackups.sh install
./borgbackups.sh backup
./borgbackups.sh cleanup
```

## config options

`addons/borgbackups.sh` has the following config options.

```
# space separated list of directories to keep borg
# incremental deduplicated backups for
BORG_BACKUPTARGETS='/root/.ssh /root/tools /root/centminlogs /usr/local/nginx/conf /usr/local/nginx/conf/conf.d /etc/centminmod'

# where borgbackups.sh logs get saved
BORG_BACKUPLOGS='/home/borgbackups-logs'

# where your backups get stored with encryption
BORG_REPO='/home/borgbackups'

# your desired borg encryption passphrase if left blank
# passphrase will be auto generated for you and you'll
# need this passphrase to access your borg backups
# auto generated passphrase is saved to 
# /root/.config/borg/pp
BORG_PASSPHRASE=''

# set borgbackup to reserve additional free space in
# gigabytes to prevent running out of disk space
BORG_ADDITIONAL_FREESPACE='4G'

# borg prune how long to keep backups before removal
BORG_KEEP_HOURLY='24'
BORG_KEEP_DAILY='7'
BORG_KEEP_WEEKLY='4'
BORG_KEEP_MONTHLY='12'
```

## borgbackups.sh install

To install and setup borgbackups run SSH command

```
./borgbackups.sh install
source /root/.bashrc
borg info
```

```
borg info               
Repository ID: 97a25e149c89a17ca4d5fb50b10820461b63812eceb77f34b0d3499a1cf5ecec
Location: /home/borgbackups
Encrypted: Yes (repokey BLAKE2b)
Cache: /root/.cache/borg/97a25e149c89a17ca4d5fb50b10820461b63812eceb77f34b0d3499a1cf5ecec
Security dir: /root/.config/borg/security/97a25e149c89a17ca4d5fb50b10820461b63812eceb77f34b0d3499a1cf5ecec
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
All archives:                    0 B                  0 B                  0 B

                       Unique chunks         Total chunks
Chunk index:                       0                    0
```

## backup example

Example backup run using wrapper script for [borg create](https://borgbackup.readthedocs.io/en/stable/usage/create.html) commands.

```
./borgbackups.sh backup                   
borgbackup for .ssh
------------------------------------------------------------------------------
Archive name: .ssh-080719-131709
Archive fingerprint: 8c03640c4d14b354639c3bd4778d53918ac6d54c05c8beb073fc8c75583ac401
Time (start): Mon, 2019-07-08 13:17:10
Time (end):   Mon, 2019-07-08 13:17:10
Duration: 0.02 seconds
Number of files: 5
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:                3.74 kB              2.60 kB              2.60 kB
All archives:                3.74 kB              2.60 kB              2.60 kB

                       Unique chunks         Total chunks
Chunk index:                       7                    7
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:                    0 B                  0 B                  0 B
All archives:                3.74 kB              2.60 kB              2.60 kB

                       Unique chunks         Total chunks
Chunk index:                       7                    7
------------------------------------------------------------------------------
borgbackup for tools
------------------------------------------------------------------------------
Archive name: tools-080719-131711
Archive fingerprint: 854837240e494ec06871cda3df6ed3a514da7b0abccd785121abeae31567d86e
Time (start): Mon, 2019-07-08 13:17:11
Time (end):   Mon, 2019-07-08 13:17:40
Duration: 28.47 seconds
Number of files: 1975
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:              569.34 MB            209.25 MB            207.61 MB
All archives:              569.35 MB            209.26 MB            207.61 MB

                       Unique chunks         Total chunks
Chunk index:                    1763                 2129
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:                    0 B                  0 B                  0 B
All archives:              569.35 MB            209.26 MB            207.61 MB

                       Unique chunks         Total chunks
Chunk index:                    1763                 2129
------------------------------------------------------------------------------
borgbackup for centminlogs
------------------------------------------------------------------------------
Archive name: centminlogs-080719-131741
Archive fingerprint: 51407a0630126fa66e04022020bf7e122478dec717fb965d41393956d467cf2d
Time (start): Mon, 2019-07-08 13:17:42
Time (end):   Mon, 2019-07-08 13:17:43
Duration: 1.42 seconds
Number of files: 1028
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:               94.98 MB              9.01 MB            133.65 kB
All archives:              664.33 MB            218.27 MB            207.75 MB

                       Unique chunks         Total chunks
Chunk index:                    1832                 3119
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:                    0 B                  0 B                  0 B
All archives:              664.33 MB            218.27 MB            207.75 MB

                       Unique chunks         Total chunks
Chunk index:                    1832                 3119
------------------------------------------------------------------------------
borgbackup for conf
------------------------------------------------------------------------------
Archive name: conf-080719-131744
Archive fingerprint: 7cdcbd951dc099c2a4483f3c64163427c0c1288a0c93b8401d29441a74594801
Time (start): Mon, 2019-07-08 13:17:45
Time (end):   Mon, 2019-07-08 13:17:45
Duration: 0.26 seconds
Number of files: 239
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:              678.10 kB            223.70 kB            147.82 kB
All archives:              665.01 MB            218.49 MB            207.89 MB

                       Unique chunks         Total chunks
Chunk index:                    1976                 3334
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:                    0 B                  0 B                  0 B
All archives:              665.01 MB            218.49 MB            207.89 MB

                       Unique chunks         Total chunks
Chunk index:                    1976                 3334
------------------------------------------------------------------------------
borgbackup for conf.d
------------------------------------------------------------------------------
Archive name: conf.d-080719-131746
Archive fingerprint: 9d9bbd04f2514265b7317808a2104610da1d3f1f4fb9a1c1277fec9a11412f2e
Time (start): Mon, 2019-07-08 13:17:46
Time (end):   Mon, 2019-07-08 13:17:46
Duration: 0.04 seconds
Number of files: 13
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:               49.70 kB             18.12 kB              1.81 kB
All archives:              665.06 MB            218.51 MB            207.90 MB

                       Unique chunks         Total chunks
Chunk index:                    1978                 3349
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:                    0 B                  0 B                  0 B
All archives:              665.06 MB            218.51 MB            207.90 MB

                       Unique chunks         Total chunks
Chunk index:                    1978                 3349
------------------------------------------------------------------------------
borgbackup for centminmod
------------------------------------------------------------------------------
Archive name: centminmod-080719-131747
Archive fingerprint: fe7b9ede09237873f7fd90bd516017b75345d55539dc70e2e963981ef836664f
Time (start): Mon, 2019-07-08 13:17:48
Time (end):   Mon, 2019-07-08 13:17:48
Duration: 0.11 seconds
Number of files: 74
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:               44.45 kB             24.81 kB              8.05 kB
All archives:              665.10 MB            218.53 MB            207.90 MB

                       Unique chunks         Total chunks
Chunk index:                    2002                 3425
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:                    0 B                  0 B                  0 B
All archives:              665.10 MB            218.53 MB            207.90 MB

                       Unique chunks         Total chunks
Chunk index:                    2002                 3425
------------------------------------------------------------------------------
.ssh-080719-131709                   Mon, 2019-07-08 13:17:10 [8c03640c4d14b354639c3bd4778d53918ac6d54c05c8beb073fc8c75583ac401]
tools-080719-131711                  Mon, 2019-07-08 13:17:11 [854837240e494ec06871cda3df6ed3a514da7b0abccd785121abeae31567d86e]
centminlogs-080719-131741            Mon, 2019-07-08 13:17:42 [51407a0630126fa66e04022020bf7e122478dec717fb965d41393956d467cf2d]
conf-080719-131744                   Mon, 2019-07-08 13:17:45 [7cdcbd951dc099c2a4483f3c64163427c0c1288a0c93b8401d29441a74594801]
conf.d-080719-131746                 Mon, 2019-07-08 13:17:46 [9d9bbd04f2514265b7317808a2104610da1d3f1f4fb9a1c1277fec9a11412f2e]
centminmod-080719-131747             Mon, 2019-07-08 13:17:48 [fe7b9ede09237873f7fd90bd516017b75345d55539dc70e2e963981ef836664f]
```

Ending output lists the borg repo names created

```
------------------------------------------------------------------------------
.ssh-080719-131709                   Mon, 2019-07-08 13:17:10 [8c03640c4d14b354639c3bd4778d53918ac6d54c05c8beb073fc8c75583ac401]
tools-080719-131711                  Mon, 2019-07-08 13:17:11 [854837240e494ec06871cda3df6ed3a514da7b0abccd785121abeae31567d86e]
centminlogs-080719-131741            Mon, 2019-07-08 13:17:42 [51407a0630126fa66e04022020bf7e122478dec717fb965d41393956d467cf2d]
conf-080719-131744                   Mon, 2019-07-08 13:17:45 [7cdcbd951dc099c2a4483f3c64163427c0c1288a0c93b8401d29441a74594801]
conf.d-080719-131746                 Mon, 2019-07-08 13:17:46 [9d9bbd04f2514265b7317808a2104610da1d3f1f4fb9a1c1277fec9a11412f2e]
centminmod-080719-131747             Mon, 2019-07-08 13:17:48 [fe7b9ede09237873f7fd90bd516017b75345d55539dc70e2e963981ef836664f]
```

Get borg repo info for repo name = `.ssh-080719-131709`

```
borg info ::.ssh-080719-131709
```

```
borg info ::.ssh-080719-131709
Archive name: .ssh-080719-131709
Archive fingerprint: 8c03640c4d14b354639c3bd4778d53918ac6d54c05c8beb073fc8c75583ac401
Comment: .ssh
Hostname: test
Username: root
Time (start): Mon, 2019-07-08 13:17:10
Time (end): Mon, 2019-07-08 13:17:10
Duration: 0.02 seconds
Number of files: 5
Command line: /usr/bin/borg create -e /home/nginx/domains/demodomain.com/log -e /home/nginx/domains/demodomain.com/backup --stats --comment .ssh --compression auto,zstd,6 ::.ssh-080719-131709 /root/.ssh
Utilization of maximum supported archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:                1.51 kB              1.38 kB              2.60 kB
All archives:              665.10 MB            218.53 MB            207.90 MB

                       Unique chunks         Total chunks
Chunk index:                    2002                 3425
```

## borg list

Using [borg list](https://borgbackup.readthedocs.io/en/stable/usage/list.html) command you can list contents of a specific borg repo name

```
borg list
.ssh-080719-131709                   Mon, 2019-07-08 13:17:10 [8c03640c4d14b354639c3bd4778d53918ac6d54c05c8beb073fc8c75583ac401]
tools-080719-131711                  Mon, 2019-07-08 13:17:11 [854837240e494ec06871cda3df6ed3a514da7b0abccd785121abeae31567d86e]
centminlogs-080719-131741            Mon, 2019-07-08 13:17:42 [51407a0630126fa66e04022020bf7e122478dec717fb965d41393956d467cf2d]
conf-080719-131744                   Mon, 2019-07-08 13:17:45 [7cdcbd951dc099c2a4483f3c64163427c0c1288a0c93b8401d29441a74594801]
conf.d-080719-131746                 Mon, 2019-07-08 13:17:46 [9d9bbd04f2514265b7317808a2104610da1d3f1f4fb9a1c1277fec9a11412f2e]
centminmod-080719-131747             Mon, 2019-07-08 13:17:48 [fe7b9ede09237873f7fd90bd516017b75345d55539dc70e2e963981ef836664f]
```

list contents of borg repo named = `conf.d-080719-131746`

```
borg list ::conf.d-080719-131746
drwxr-xr-x root   root          0 Sat, 2019-07-06 15:30:35 usr/local/nginx/conf/conf.d
-rw-r--r-- root   root       1102 Tue, 2019-06-25 19:11:48 usr/local/nginx/conf/conf.d/demodomain.com.conf
```

## borg export-tar

Using [borg export-tar](https://borgbackup.readthedocs.io/en/stable/usage/tar.html) command you can export a specific borg repo back to tar format

```
borg list
.ssh-080719-131709                   Mon, 2019-07-08 13:17:10 [8c03640c4d14b354639c3bd4778d53918ac6d54c05c8beb073fc8c75583ac401]
tools-080719-131711                  Mon, 2019-07-08 13:17:11 [854837240e494ec06871cda3df6ed3a514da7b0abccd785121abeae31567d86e]
centminlogs-080719-131741            Mon, 2019-07-08 13:17:42 [51407a0630126fa66e04022020bf7e122478dec717fb965d41393956d467cf2d]
conf-080719-131744                   Mon, 2019-07-08 13:17:45 [7cdcbd951dc099c2a4483f3c64163427c0c1288a0c93b8401d29441a74594801]
conf.d-080719-131746                 Mon, 2019-07-08 13:17:46 [9d9bbd04f2514265b7317808a2104610da1d3f1f4fb9a1c1277fec9a11412f2e]
centminmod-080719-131747             Mon, 2019-07-08 13:17:48 [fe7b9ede09237873f7fd90bd516017b75345d55539dc70e2e963981ef836664f]
```

borg export-tar to a zstd compressed tar archive file the borg repo named = `conf.d-080719-131746` which contains your Centmin Mod Nginx Nginx vhost config files usually located at `/usr/local/nginx/conf/conf.d`

```
borg export-tar --tar-filter="zstd -6 --rsyncable" /home/borgbackups::conf.d-080719-131746 conf.d-080719-131746.tar.zst
```

resulting zstd compressed tar archive `conf.d-080719-131746.tar.zst` listing
```
ls -lahrt | grep conf.d
-rw-------  1 root root 4.6K Jul  8 13:29 conf.d-080719-131746.tar.zst
```

test inspection of zstd compressed tar archive without actually extracting contents

```
tar -I "zstd -d" -tvf  conf.d-080719-131746.tar.zst
```

```
tar -I "zstd -d" -tvf  conf.d-080719-131746.tar.zst
drwxr-xr-x root/root         0 2019-07-06 15:30 usr/local/nginx/conf/conf.d/
-rw-r--r-- root/root      1102 2019-06-25 19:11 usr/local/nginx/conf/conf.d/demodomain.com.conf
```