#! /usr/bin/env bash
# -*- coding: utf-8; indent-tabs-mode: nil; tab-width: 4; c-basic-offset: 4; -*-
#
# Copyright (C) 2013 Shih-Yuan Lee (FourDollars) <fourdollars@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e
eval set -- $(getopt -o "hl:u:" -l "help,lower-bound:,upper-bound:" -- $@)

while :; do
    case "$1" in
        ('-h'|'--help')
            cat <<ENDLINE
Usage $0:
    -h|--help                This manual
    -l|--lower-bound NUM     Lower bound
    -u|--upper-bound NUM     Upper bound
ENDLINE
            exit;;
        ('-l'|'--lower-bound')
            min="$2"
            shift 2;;
        ('-u'|'--upper-bound')
            max="$2"
            shift 2;;
        ('--')
            shift
            break;;
    esac
done

url='http://kernel.ubuntu.com/~kernel-ppa/mainline'
height="$((`tput lines`-3))"
width="$((`tput cols`-8))"

vers=`wget -q $url -O - | grep -o 'href="v[^"]*"' | grep -o '[0-9][^/]*'`
num=$(echo $vers | xargs -n1 | wc -l)

for ver in $vers; do
    debver=`echo $ver | sed 's/-rc/~rc/'`
    if [ -n "$min" -a -n "$max" ]; then
        if dpkg --compare-versions $debver gt $min && dpkg --compare-versions $debver lt $max; then
            downloads="$downloads $ver"
        fi
    elif [ -n "$min" ]; then
        if dpkg --compare-versions $debver gt $min; then
            downloads="$downloads $ver"
        fi
    elif [ -n "$max" ]; then
        if dpkg --compare-versions $debver lt $max; then
            downloads="$downloads $ver"
        fi
    else
        downloads="$downloads $ver"
    fi
done

echo $downloads | xargs -n6 | column -t

read -p 'Would you like to install these kernels: [y/N] ' answer

if [ -z "$answer" -o "$answer" != 'y' ]; then
    exit 0
fi

for ver in $downloads; do
    pkgs=`wget -q $url/v$ver/ -O - | grep -o 'linux[^"]*\(all\|amd64\).deb' | sort -u`
    mkdir -p "$PWD/mainline/v$ver"
    for pkg in $pkgs; do
        [ -f "$PWD/mainline/v$ver/$pkg" ] || wget -nv "$url/v$ver/$pkg" -O "$PWD/mainline/v$ver/$pkg"
    done
    sudo dpkg -i $PWD/mainline/v$ver/*.deb
done


# vim:fileencodings=utf-8:expandtab:tabstop=4:shiftwidth=4:softtabstop=4
