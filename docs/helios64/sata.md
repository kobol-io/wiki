## Serial ATA (SATA)

Helios64 use the JMicron JMB585 controller, this controller support up to 5 port SATA devices.
The SATA controller support following features: 

- 5 SATA ports,
- command-based and FIS-based for Port Multiplier,
- compliance with SATA Specification Revision 3.2,
- AHCI mode and IDE programming interface,
- Native Command Queue (NCQ),
- SATA link power saving mode (partial and slumber),
- SATA plug-in detection capable,
- drive power control and staggered spin-up,
- SATA Partial / Slumber power management state.

the SATA Controller is connected to the PCIe port in RK3399, the PCIe bus is compatible with PCI Express Base Specification Revision 2.1.
Bandwidth of this PCIe is 5GT/s.

Following graphics is showing the mux diagram of the SATA Controller:

bikin diagram mux (multiplexer) seperti di USB (/helios64/usb/#usb-type-c-functionality-on-helios64)

The power delivery of the SATA Controller is devided into two group, this power control scenario is performed to reduce the inrush current when all the HDDs turned on simultaneously. 
The 8 Pin MOLEX connector for the SATA Connector is devided into two group. The first group will power on 3 HDDs in the initial stage, and the second group will power on another 2 HDDs later. 

disebelah connector battery ada MOLEX 8 pin klo ga salah. itu nanti pake kabel khusus biar keluar jadi MOLEX yg SATA
grup 1 aktif duluan, nyalain 3 HDD. nanti beberapa saat kemudian grup 2 aktif buat nyalain sisanya (2 HDD)
