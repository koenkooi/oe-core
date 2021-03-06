#!/bin/bash
#
# Copyright (c) 2011, Intel Corporation.
# All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# DESCRIPTION
# This script runs BB_CMD (typically building core-image-sato) for all
# combincations of BB_RANGE and PM_RANGE values. It saves off all the console
# logs, the buildstats directories, and creates a bb-pm-runtime.dat file which
# can be used to postprocess the results with a plotting tool, spreadsheet, etc.
# Before running this script, it is recommended that you pre-download all the
# necessary sources by performing the BB_CMD once manually. It is also a good
# idea to disable cron to avoid runtime variations caused by things like the
# locate process. Be sure to sanitize the dat file prior to post-processing as
# it may contain error messages or bad runs that should be removed.
#
# AUTHORS
# Darren Hart <dvhart@linux.intel.com>
#

# The following ranges are appropriate for a 4 core system with 8 logical units
BB_RANGE="04 05 06 07 08 09 10 11 12 13 14 15 16"
PM_RANGE="04 05 06 07 08 09 10 11 12 13 14 15 16"

DATADIR="bb-matrix-$$"
BB_CMD="bitbake core-image-minimal"
RUNTIME_LOG="$DATADIR/bb-matrix.dat"

# See TIME(1) for a description of the time format parameters
# The following all report 0: W K r s t w
TIME_STR="%e %S %U %P %c %w %R %F %M %x"

# Prepare the DATADIR
mkdir $DATADIR
if [ $? -ne 0 ]; then
	echo "Failed to create $DATADIR."
	exit 1
fi

# Add a simple header
echo "BB PM $TIME_STR" > $RUNTIME_LOG
for BB in $BB_RANGE; do
	for PM in $PM_RANGE; do
		RUNDIR="$DATADIR/$BB-$PM-build"
		mkdir $RUNDIR
		BB_LOG=$RUNDIR/$BB-$PM-bitbake.log
		date
		echo "BB=$BB PM=$PM Logging to $BB_LOG"

		# Export the variables under test and run the bitbake command
		export BB_NUMBER_THREADS=$(echo $BB | sed 's/^0*//')
		export PARALLEL_MAKE="-j $(echo $PM | sed 's/^0*//')"
		/usr/bin/time -f "$BB $PM $TIME_STR" -a -o $RUNTIME_LOG $BB_CMD &> $BB_LOG
		
		echo "  $(tail -n1 $RUNTIME_LOG)"
		echo -n "  Cleaning up..."
		mv tmp/buildstats $RUNDIR/$BB-$PM-buildstats
		rm -f pseudodone &> /dev/null
		rm -rf tmp &> /dev/null
		rm -rf sstate-cache &> /dev/null
		rm -rf tmp-eglibc &> /dev/null
		echo "done"
	done
done
