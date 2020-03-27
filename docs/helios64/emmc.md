## eMMC

Helios64 use the Samsung KLMAG1JETD-B041 chip, this storage has features:

 - embedded MultiMediaCard Ver. 5.1 compatible.
 - SAMSUNG eMMC supports features of eMMC5.1 which are defined in JEDEC Standard.
 - Major Supported Features : HS400, Field Firmware Update, Cache, Command Queuing, Enhanced Strobe Mode, Secure Write Protection, Partition types.
 - Non-supported Features : Large Sector Size (4KB).
 - Backward compatibility with previous MultiMediaCard system specification (1bit data bus, multi-eMMC systems).
 - Data bus width : 1bit (Default), 4bit and 8bit.
 - MMC I/F Clock Frequency : 0 ~ 200MHz
 - MMC I/F Boot Frequency : 0 ~ 52MHz

SAMSUNG eMMC adopts Enhanced User Data Area as Single-Level Cell (SLC) Mode.
Therefore when master adopts some portion as enhanced user data area in User Data Area, that area occupies double size of original set up size. (ex> if master set 1MB for enhanced mode, total 2MB user data area is needed to generate 1MB enhanced area).

The eMMC chip installed in Helios64 support the HS400 MODE, with following features:

 - eMMC 5.1 product supports high speed DDR interface timing mode up to 400MB/s at 200MHz with 1.8V I/O supply.
 - HS400 mode supports the following features:
 - DDR Data sampling method
 - CLK frequency up to 200MHz DDR (up to 400Mbps)
 - Only 8-bits bus width available
 - Signaling levels of 1.8V
 - Six selectable Drive Strength (refer to the table below)

Following table describe the I/O Driver Strength Types

![driver type](/helios64/img/emmc/driver-type.png)
		
Support of Driver Type-0 is default for HS200 & HS400 Device
