.globl clock_init

clock_init:
	
	/* 1.\u8bbe\u7f6eLOCK_TIME */
	ldr r0, =0x7E00F000  /* APLL_LOCK */
	ldr r1, =0x0000FFFF
	str r1, [r0]
	
	str r1, [r0, #4]	 /* MPLL_LOCK */
	str r1, [r0, #8]	 /* EPLL_LOCK */	
	
#define OTHERS		0x7e00f900
	@ set async mode  /* \u5f53CPU\u65f6\u949f != HCLK\u65f6\uff0c\u8981\u8bbe\u4e3a\u5f02\u6b65\u6a21\u5f0f */
	ldr r0, =OTHERS
	ldr r1, [r0]
	bic r1, #0xc0			
	str r1, [r0]

loop1:				/* \u7b49\u5f85\uff0c\u76f4\u5230CPU\u8fdb\u5165\u5f02\u6b65\u6a21\u5f0f */
	ldr r0, =OTHERS
	ldr r1, [r0]
	and r1, #0xf00					
	cmp r1, #0
	bne loop1		
	
	/* SYNC667 */
	/* MISC_CON[19] = 0 */

#define ARM_RATIO    0   /* ARMCLK = DOUTAPLL / (ARM_RATIO + 1)    */
#define HCLKX2_RATIO 1   /* HCLKX2 = HCLKX2IN / (HCLKX2_RATIO + 1) */
#define HCLK_RATIO   1   /* HCLK = HCLKX2 / (HCLK_RATIO + 1)       */
#define PCLK_RATIO   3   /* PCLK   = HCLKX2 / (PCLK_RATIO + 1)     */
#define MPLL_RATIO   0   /* DOUTMPLL = MOUTMPLL / (MPLL_RATIO + 1)     */
	ldr r0, =0x7E00F020  /* CLK_DIV0 */
	ldr r1, =(ARM_RATIO) | (MPLL_RATIO << 4) | (HCLK_RATIO << 8) | (HCLKX2_RATIO << 9) | (PCLK_RATIO << 12)
	str r1, [r0]
	
	/* 2.\u914d\u7f6e\u65f6\u949f */
	/* 2.1 \u914d\u7f6eAPLL */
	/* 2.1.1 \u8bbe\u7f6eAPLL
	 * 2.1.2 MUXAPLL
	 * 2.1.3 SYNC667
	 * 2.1.4 DIVAPLL
	 */
#define APLL_CON_VAL  ((1<<31) | (266 << 16) | (3 << 8) | (1))
	ldr r0, =0x7E00F00C
	ldr r1, =APLL_CON_VAL
	str r1, [r0]		/* APLL_CON, FOUTAPL = MDIV * Fin / (PDIV*2^SDIV) = 266*12/(3*2^1) = 532MHz  */
	
	/* 2.2 \u914d\u7f6eMPLL */
	/* 2.2.1 \u8bbe\u7f6eMPLL
	 * 2.2.2 MUXMPLL
	 * 2.2.3 SYNCMUX
	 * 2.2.4 SYNC667
	 * 2.2.5 HCLKX2_RATIO
	 * 2.2.6 PCLK_RATIO
	 */
#define MPLL_CON_VAL  ((1<<31) | (266 << 16) | (3 << 8) | (1))
	ldr r0, =0x7E00F010
	ldr r1, =MPLL_CON_VAL
	str r1, [r0]		/* MPLL_CON, FOUTMPL = MDIV * Fin / (PDIV*2^SDIV) = 266*12/(3*2^1) = 532MHz  */
	
	/* 3.\u9009\u62e9PLL\u7684\u8f93\u51fa\u4f5c\u4e3a\u65f6\u949f\u6e90 */
	ldr r0, =0x7E00F01C
	ldr r1, =0x03
	str r1, [r0]
	
	mov pc, lr


