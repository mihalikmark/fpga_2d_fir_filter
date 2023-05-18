/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xuartlite.h"
#include "xparameters.h"
#include <math.h>
#include "stdlib.h"

#define FIXED_POINT_FRACTIONAL_BITS 8
#define UART_DEVICE_ID		XPAR_AXI_UARTLITE_0_DEVICE_ID
#define UART_BUFFER_SIZE	2000
#define COEFF_BUFFER_SIZE	25

static XUartLite UARTLite;
u8 RecvBuffer[UART_BUFFER_SIZE];
typedef i16 fixed_point_t;

inline fixed_point_t float2fixed_point(float number)
{
	return (fixed_point_t)(round(number * (1 << FIXED_POINT_FRACTIONAL_BITS)));
}

int main()
{
    init_platform();

    int Status;
    int ReceivedCount = 0;
    boolean dataValid;

	Status = XUartLite_Initialize(&UARTLite, UART_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XUartLite_SelfTest(&UartLite);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	while(1)
	{
		ReceivedCount += XUartLite_Recv(
							&UartLite,
							RecvBuffer + ReceivedCount,
							UART_BUFFER_SIZE - ReceivedCount);
		printf(UartLite[ReceivedCount]);
		if (UartLite[ReceivedCount] == '\n')
		{
			dataValid = true;

		}
	}

    cleanup_platform();
    return 0;
}
