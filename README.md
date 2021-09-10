# 6502-Computer

Here is a basic computer I built using a WDC 65c02 microprocessor following Ben Eater's 6502 computer build series of videos on Youtube. 

# Final Build
![IMG_1773 (1)](https://user-images.githubusercontent.com/88196425/132850734-156e85ee-5570-49d5-b540-faf1091bd4d7.jpg)

Here is a annotated version of the final build, showing how I set up the address lines and data lines.
![IMG_0012](https://user-images.githubusercontent.com/88196425/132850901-cb8a3f33-8176-4b80-b499-e7d3f57b87a4.jpg)

# Memory Map 

Address | Description
--- | ---
0x0000-0x3FFF | SRAM (0100-01FF Call Stack)
0x0400-0x5FFF | Reserved
0x6000-0x6003 | I/O (VIA)
0x6004-0x7FFF | Reserved
0x8000-0xFFFF | ROM

Although there is a decent chunk of the address space being 'unused', the trade-off is that the digital logic only uses 3 NAND gates for
the entire build.

