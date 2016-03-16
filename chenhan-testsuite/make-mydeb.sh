#! /usr/bin/env bash
# -*- coding: utf-8; indent-tabs-mode: nil; tab-width: 4; c-basic-offset: 4; -*-
#
# Copyright (C) 2015 Chen-Han Hsiao (Stanley) <r97922120@ntu.edu.tw>
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

DIR=/usr/local/mydebs
mkdir -p $DIR
cd $DIR
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

# add the line
# deb file:/usr/local/mydebs ./
# to your /etc/apt/sources.list, and you're done.

# vim:fileencodings=utf-8:expandtab:tabstop=4:shiftwidth=4:softtabstop=4

