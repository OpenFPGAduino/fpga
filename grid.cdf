/* Quartus II 32-bit Version 12.1 Build 243 01/31/2013 Service Pack 1 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Cfg)
		Device PartName(EP4CE15F23) Path("/home/zhizhouli/meteroi/grid/output/") File("grid.sof") MfrSpec(OpMask(1));
	P ActionCode(Ign)
		Device PartName(EPM1270) MfrSpec(OpMask(0));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
