My ROMVault Post-Processing PowerShell Scripts

# USE CASE
My use case is very simple: I've a limited space to store all my No-Intro ROMs / ReDump ISOs / Scene Files.
All files are checked and fixed with ROMVault. For some of them, I've discovered that we are able to improve the compression ratio.

The default ROMVault compression method is TorrentZipping.
The best ratio I've got is with FreeArc 0.666 but the inside files are not readable anymore. It's not the result I wanted.
The second best result I've got is to use 7-Zip with LZMA compression method (I don't get why with the LZMA2 method, I can't get better results).

Also, I've discovered that inside the same ROMSet and only for some files, I can get better compression ratio with my method than with the ROMVault's one.
This script allows to optimize the utilization of the disk space.

# RESULT
I'm currently working on the result to know if it worths but I've 15TB to work with.
