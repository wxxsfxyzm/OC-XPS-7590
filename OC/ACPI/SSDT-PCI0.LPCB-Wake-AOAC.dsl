/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLJFpTqG.aml, Thu Dec  2 23:00:08 2021
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000009E (158)
 *     Revision         0x02
 *     Checksum         0xEA
 *     OEM ID           "ACDT"
 *     OEM Table ID     "AOACWake"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "AOACWake", 0x00000000)
{
    External (_SB_.LID0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.LID0.AOAC, IntObj)
    External (_SB_.ACEV, MethodObj)

    Scope (_SB.PCI0.LPCB)
    {
        If (_OSI ("Darwin"))
        {
            Method (_PS0, 0, Serialized)  // _PS0: Power State 0
            {
                \_SB.PCI8.AOAC = One 
                Notify (\_SB.LID0, 0x80) 
                Sleep (200) 
                \_SB.LID0.AOAC = Zero
                \_SB.ACEV()
            }
            
            Method (_PS3, 0, Serialized)  // _PS3: Power State 3
            {
            }
        }
    }
}

