//////////////////////////////////////////////////////////////////////////////////
// Company: Ussash Arafat 
// 
// Create Date: 02/18/2021 11:24:01 PM
// Design: SPI Slave Core
// Module Name: SPI_SLAVE_CORE
// Project Name: SPI_SLAVE_CORE
// Target Devices: Zedboard
// Tool Versions: Xilinx Vivado 2020.2
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module TB_SPI_SLAVE_CORE();
reg CLK,RST,SCLK,MOSI,SSN;
reg [15:0] RDATA;
wire MISO,WSTROBE;
wire [15:0] WDATA;
wire [6:0]ADDR;

SPI_SLAVE_CORE UUT(CLK,RST,SCLK,MOSI,SSN,RDATA,MISO,WSTROBE,WDATA,ADDR);

initial begin
    CLK = 1'b0;
    forever #10 CLK = ~CLK;
end

initial begin
    SCLK = 1'b0;
    #400 SCLK = ~SCLK;
    forever #50 SCLK = ~SCLK;
end

initial begin
    SSN =1'b1;
    #300 SSN = ~SSN;
    #2500 SSN = ~SSN;
end

initial begin
    RST = 1'b1;
    #15 RST = 1'b0;
    #10 RST = 1'b1;
end

initial begin
    RDATA = 16'h000;
    #1100 RDATA = 16'h8321;
end

initial begin
    MOSI = 1'b0;
    #400 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b1;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b0;
    #100 MOSI = 1'b1;   
end

endmodule
