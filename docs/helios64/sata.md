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

Following graphics is showing the mux diagram of the SATA1 port and the M.2 connector :

![!SATA data connection](/helios64/img/sata/sata-m2-mux.png)

The M.2 devices installed in Helios64 is configured as sharing devices with SATA Port 1.
Therefore if you install M.2 SATA module, you will not be able to access the SATA Port 1.

The power delivery of the SATA Controller is devided into two group, this power control scenario is performed to reduce the inrush current when all the HDDs turned on simultaneously. 
The 8 Pin MOLEX connector for the SATA Connector is devided into two group (you will have custom cable from 8Pin Molex to 5 SATAs power connector).
The first group will power on 3 HDDs in the initial stage, and the second group will power on another 2 HDDs later. 

