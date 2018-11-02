/*
 * (C) Copyright 2012 Stephen Warren
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

.globl lowlevel_init
lowlevel_init:

		/* Peri port setup */
		ldr r0, =0x70000000
		orr r0, r0, #0x13
		mcr p15,0,r0,c15,c2,4		@ 256M(0x70000000-0x7fffffff)
		

	/* \u5f80WTCON(0x7E004000)\u51990 */
		
		ldr r0, =0x7E004000  /* \u4f2a\u6307\u4ee4 */
		mov r1, #0
		str r1, [r0]
		
		ldr sp, =8*1024
		sub sp,sp,#4
		str lr, [sp] 
		
		bl clock_init
		//bl uart_init
		bl sdram_init	

		ldr lr,[sp] 
		mov	pc, lr