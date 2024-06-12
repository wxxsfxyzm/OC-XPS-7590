// Disables DGPU
//
DefinitionBlock("", "SSDT", 2, "OCLT", "NDGP", 0)
{
    External(_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
 
    If (_OSI ("Darwin"))
    {
        Device(DGPU)
        {
            Name(_HID, "DGPU1000")
            Method (_INI, 0, NotSerialized)
            {
                If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF))                {
                    \_SB.PCI0.PEG0.PEGP._OFF()
                }
            }
        }
    }
}
//EOF