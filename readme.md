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

Example backup run

```
./borgbackups.sh backup
borgbackup for .ssh
------------------------------------------------------------------------------
Archive name: .ssh-080719-104919
Archive fingerprint: c1506b95997933ed217287982dfa938acd057abf72a001cb656bf95a46b6f0e5
Time (start): Mon, 2019-07-08 10:49:20
Time (end):   Mon, 2019-07-08 10:49:20
Duration: 0.03 seconds
Number of files: 5
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:                3.01 kB              2.41 kB                488 B
All archives:              664.94 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1972                 3402
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:               -3.01 kB             -2.41 kB               -490 B
All archives:              664.94 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1971                 3395
------------------------------------------------------------------------------
borgbackup for tools
------------------------------------------------------------------------------
Archive name: tools-080719-104921
Archive fingerprint: 12331f335ef0220b6f3c96392c84b8249b4fb47532a8495646244da74954e459
Time (start): Mon, 2019-07-08 10:49:21
Time (end):   Mon, 2019-07-08 10:49:22
Duration: 0.64 seconds
Number of files: 1975
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:              569.34 MB            206.99 MB                598 B
All archives:                1.23 GB            423.23 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1972                 5507
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:             -569.34 MB           -206.99 MB               -598 B
All archives:              664.94 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1971                 3395
------------------------------------------------------------------------------
borgbackup for centminlogs
------------------------------------------------------------------------------
Archive name: centminlogs-080719-104923
Archive fingerprint: bbe765f8bba06070358cf924447b1e2db1be2bba9be64f8106fdb2c42f57d5bd
Time (start): Mon, 2019-07-08 10:49:24
Time (end):   Mon, 2019-07-08 10:49:24
Duration: 0.24 seconds
Number of files: 1013
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:               94.83 MB              8.99 MB             60.67 kB
All archives:              759.77 MB            225.22 MB            201.94 MB

                       Unique chunks         Total chunks
Chunk index:                    1975                 4366
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:              -94.82 MB             -8.98 MB            -59.47 kB
All archives:              664.95 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1972                 3396
------------------------------------------------------------------------------
borgbackup for conf
------------------------------------------------------------------------------
Archive name: conf-080719-104925
Archive fingerprint: 144f15afa1114fd42c95d3e8cd2e82838069b044236eb1689d381b4f357978ea
Time (start): Mon, 2019-07-08 10:49:26
Time (end):   Mon, 2019-07-08 10:49:26
Duration: 0.09 seconds
Number of files: 239
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:              677.38 kB            217.77 kB                499 B
All archives:              665.62 MB            216.46 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1973                 3611
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:             -677.38 kB           -217.77 kB               -499 B
All archives:              664.95 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1972                 3396
------------------------------------------------------------------------------
borgbackup for conf.d
------------------------------------------------------------------------------
Archive name: conf.d-080719-104927
Archive fingerprint: be92ad39ffa55cabf801f1652617fd2b38e47ba7ad2ab7be65a39765725cbfd4
Time (start): Mon, 2019-07-08 10:49:28
Time (end):   Mon, 2019-07-08 10:49:28
Duration: 0.03 seconds
Number of files: 13
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:               48.98 kB             17.92 kB                504 B
All archives:              664.99 MB            216.26 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1973                 3411
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:              -48.98 kB            -17.92 kB               -505 B
All archives:              664.95 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1972                 3396
------------------------------------------------------------------------------
borgbackup for centminmod
------------------------------------------------------------------------------
Archive name: centminmod-080719-104929
Archive fingerprint: 7f1eb40552197ceaf00695fcf818af334c21dfac59e845fc17182206f7c7adb2
Time (start): Mon, 2019-07-08 10:49:30
Time (end):   Mon, 2019-07-08 10:49:30
Duration: 0.06 seconds
Number of files: 74
Utilization of max. archive size: 0%
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
This archive:               43.73 kB             24.75 kB                498 B
All archives:              664.99 MB            216.26 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1973                 3472
------------------------------------------------------------------------------
------------------------------------------------------------------------------
                       Original size      Compressed size    Deduplicated size
Deleted data:              -43.73 kB            -24.75 kB               -498 B
All archives:              664.95 MB            216.24 MB            201.88 MB

                       Unique chunks         Total chunks
Chunk index:                    1972                 3396
------------------------------------------------------------------------------
.ssh-080719-104919                   Mon, 2019-07-08 10:49:20 [c1506b95997933ed217287982dfa938acd057abf72a001cb656bf95a46b6f0e5]
tools-080719-104921                  Mon, 2019-07-08 10:49:21 [12331f335ef0220b6f3c96392c84b8249b4fb47532a8495646244da74954e459]
centminlogs-080719-104923            Mon, 2019-07-08 10:49:24 [bbe765f8bba06070358cf924447b1e2db1be2bba9be64f8106fdb2c42f57d5bd]
conf-080719-104925                   Mon, 2019-07-08 10:49:26 [144f15afa1114fd42c95d3e8cd2e82838069b044236eb1689d381b4f357978ea]
conf.d-080719-104927                 Mon, 2019-07-08 10:49:28 [be92ad39ffa55cabf801f1652617fd2b38e47ba7ad2ab7be65a39765725cbfd4]
centminmod-080719-104929             Mon, 2019-07-08 10:49:30 [7f1eb40552197ceaf00695fcf818af334c21dfac59e845fc17182206f7c7adb2]
```