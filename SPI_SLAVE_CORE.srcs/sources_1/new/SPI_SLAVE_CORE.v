////////////////////////////////////////////////////////////////////////////////// 
// Designer: Ussash Arafat
// 
// Create Date: 02/18/2021 07:11:14 PM
// Design: SPI Slave Core
// Module Name: SPI_SLAVE_CORE
// Project Name: SPI_SLAVE_CORE
// Target Devices: Zedboard
// Tool Versions: Xilinx Vivado 2020.2
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module SPI_SLAVE_CORE(
    input wire CLK,
    input wire RST,
    input wire SCLK,
    input wire MOSI,
    input wire SSN,
    input wire [15:0] RDATA,
    output reg MISO,
    output reg WSTROBE,
    output reg [15:0] WDATA,
    output reg [6:0] ADDR
    );
    
    //Internal Signals
    reg [4:0] BIT_COUNT;
    reg [15:0] RDATA_REG;
    reg READ_WRITE;
    reg [6:0] SYSTEM_COUNTER;
    
    always @(posedge CLK or negedge RST)
    begin
        if(!RST)
            SYSTEM_COUNTER <= 0;
        else if(SYSTEM_COUNTER == 77)
            SYSTEM_COUNTER <= 0;
        else if(BIT_COUNT > 8)
            SYSTEM_COUNTER <= SYSTEM_COUNTER + 1;
        else
            SYSTEM_COUNTER <= SYSTEM_COUNTER;
    end            
   
    //Indication of Data Ready
    always @(posedge CLK or negedge RST)
    begin
        if(!RST)
            WSTROBE = 0;
        else if(SYSTEM_COUNTER == 77)
            WSTROBE = 1;
        else
            WSTROBE = 0;
    end
    
    //Serial Bit Counter
    always @(posedge SCLK or negedge RST)
    begin
        if(!RST)
            BIT_COUNT <= 0;
        else
            if (SSN)
                BIT_COUNT <= 0;
             else
                BIT_COUNT <= BIT_COUNT + 1; 
     end
    
    //Extracting bit 23-17 (ADDRESS)
    always @(negedge SCLK or negedge RST)
    begin
        if(!RST)
            ADDR <= 0;
        else if(BIT_COUNT > 0 && BIT_COUNT <= 7)
        begin
            ADDR[0] <= MOSI;
            ADDR[6:1] <= ADDR[5:0];
        end
        else
            ADDR <= ADDR;   
    end
    
    //Extracting bit 16 (READ/WRITE)
    always @(negedge SCLK  or negedge RST)
    begin
        if(!RST)
            READ_WRITE <= 0;
        else
            if(BIT_COUNT == 8)
            begin
                READ_WRITE = MOSI;
            end
            else 
                READ_WRITE = 0;
     end
     
     //Extracting bit 15-0 (DATA)
     always @(negedge SCLK or negedge RST)
     begin
        if(!RST)
            WDATA <= 0;
        else
            if(BIT_COUNT >= 9)
            begin
                WDATA[0] <= MOSI;
                WDATA[15:1] <= WDATA[14:0];
            end 
            else
                WDATA = WDATA;
     end
    
    //Read Operation 
     always @(negedge SCLK or negedge RST)
     begin
        if(!RST)
        begin
            MISO <= 0;
            RDATA_REG <= 0;
        end
        else if(BIT_COUNT == 8)
            RDATA_REG <= RDATA;
        else
        begin
            MISO <= RDATA_REG[15];
            RDATA_REG <= {RDATA_REG[14:0],1'b0};
        end
     end
endmodule
