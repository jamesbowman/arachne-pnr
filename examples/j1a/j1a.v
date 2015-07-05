`default_nettype none
`include "common.h"

module top(input clk, output D1, output D2, output D3, output D4, output D5,
           output TXD,
           input RXD,
           output J3_10
);
  localparam MHZ = 12;

  wire io_rd, io_wr;
  wire [15:0] mem_din = 16'd0000;
  wire [15:0] mem_addr;
  wire mem_wr;
  wire [15:0] dout;
  wire [15:0] io_din = 16'd0000;
  wire [15:0] mem_din = 16'd0000;
  wire [12:0] code_addr;
  reg [15:0] insn;

  always @(posedge clk)
    case (code_addr[2:0])
    // 0: insn <= 16'h8001;
    // 1: insn <= 16'h6203;
    // 2: insn <= 16'h6040;
    // 3: insn <= 16'h0000;
    0: insn <= 16'h804A;
    1: insn <= 16'h8001;
    2: insn <= 16'h6043;
    3: insn <= 16'h6103;
    4: insn <= 16'h0000;
    5: insn <= 16'h608C;
    6: insn <= 16'h0000;
    7: insn <= 16'h0000;
    endcase


  j1 _j1(
    .clk(clk),
    .resetq(1'b1),
    .io_rd(io_rd),
    .io_wr(io_wr),
    .dout(dout),
    .io_din(io_din),
    .mem_din(mem_din),
    .mem_addr(mem_addr),
    .code_addr(code_addr),
    .insn(insn));

  reg [3:0] q;
  always @(posedge clk)
    if (io_wr)
       q <= mem_addr[3:0];

  assign D5 = code_addr[0];
  assign {D1,D2,D3,D4} = 1;
  assign J3_10 = io_wr;

  wire uart0_valid, uart0_busy;
  wire [7:0] uart0_data;
  wire uart0_rd = 0, uart0_wr = io_wr;
  reg [31:0] uart_baud = 32'd115200;
  wire UART0_RX;
  buart #(.CLKFREQ(MHZ * 1000000)) _uart0 (
     .clk(clk),
     .resetq(1'b1),
     .baud(uart_baud),
     .rx(RXD),
     .tx(TXD),
     .rd(uart0_rd),
     .wr(io_wr),
     .valid(uart0_valid),
     .busy(uart0_busy),
     .tx_data(dout[7:0]),
     .rx_data(uart0_data));
endmodule // top
