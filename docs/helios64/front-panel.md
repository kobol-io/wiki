## Front Panel (P3)

Helios64 provides 24 front panel pinout on header P3.
User can connect the front panel PCB into the P3 in the Helios64 board by using provided ribbon cable. 
The ribbon cable are provided when you buy the Full Bundle of the Helios64 board.
Below Graphics and Table describe the layout of the front panel header.

![P3 Pinout](/helios64/img/front-panel/fp-header.png)

This header are actually located at: 
![P3 Location](/helios64/img/front-panel/fp-header-zoom.jpg)

### Front Panel Pinout Table

| PIN | Port | Remarks |
|-----|------|-------------|
| 1   | HDD LED - High Side (HS) | |
| 2   | PWR LED - HS | |
| 3   | GND          | Ground |
| 4   | GND          | Ground |
| 5   | RST Switch   | |
| 6   | PWR Switch   | | 
| 7   | USR1 Switch  | | 
| 8   | USR2 Switch  | | 
| 9   | Network Activity LED - HS | | 
| 10  | USB Activity LED - HS | |
| 11  | 3V3                  | 3.3 Volt Supply |
| 12  | SYS Green LED - HS   | |
| 13  | SYS Red LED - HS     | | 
| 14  | SATA 0 Activity - HS | | 
| 15  | SATA 0 Error - HS    | | 
| 16  | SATA 1 Activity - HS | | 
| 17  | SATA 1 Error - HS    | | 
| 18  | SATA 2 Activity - HS | | 
| 19  | SATA 2 Error - HS    | | 
| 20  | SATA 3 Activity - HS | | 
| 21  | SATA 3 Error - HS    | | 
| 22  | SATA 4 Activity - HS | |
| 23  | SATA 4 Error - HS    | | 
| 24  | GND                  | Ground |
 
### Wiring Diagram

This Figures describe the PCB layout from the left hand side (RHS) and right hand side (LHS) view respectively.
The vertical mounting of this double-sided PCB will make the front panel have two LED indicators (red and green) for Sys and HDD 1 untill HDD 5 Activity Status(or Error Status).

![Front Panel PCB RHS](/helios64/img/front-panel/fp-pcb-rhs.png)

![Front Panel PCB LHS](/helios64/img/front-panel/fp-pcb-lhs.png)

There is provided ribbon connection from the P3 at the Helios64 board to the P2 at the front panel PCB.
So you can easily connect this two parts.

!!! Warning
        Please be careful with the header polarity. Make sure that Pin no 1 at the P3 of Helios64 are connected to the no 1 at the P1 of front panel PCB.

The front panel USB 3.0 port can be directly connected to the Front USB 3.0 Port on the board, this interface are connected with regular USB 3.0 complied cable.

---TBU---

The connection between P3 from the Helios64 board to P1 on the front panel PCB board is illustrated in below figure:
![Front Panel Connection](/helios64/img/hardware/ribbon-cable-connected.jpg)



### The Front Panel Description

Below graphics show the front panel descriptions:

![Front Panel Label](/helios64/img/front-panel/front-panel-labeled.jpg)
