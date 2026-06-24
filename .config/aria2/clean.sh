#!/bin/sh
# $3 provides the path to the downloaded file
# This removes the temporary tracking metadata when complete
rm -f "$3.aria2"
rm -f "$3.torrent"
