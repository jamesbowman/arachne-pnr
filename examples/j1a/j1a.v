`default_nettype none
`include "common.h"

// module progmem #(
//     parameter DATA = 16,
//     parameter ADDR = 3
// ) (
//     input   wire                clk,
//     input   wire    [ADDR-1:0]  addr,
//     // input   wire                wr,
//     // input   wire    [DATA-1:0]  din,
//     output  reg     [DATA-1:0]  dout
// );
//  
//   reg [DATA-1:0] mem [(2**ADDR)-1:0];
//   initial begin
//     $readmemh("compiler/build/nuc.hex", mem);
//   end
//  
//   always @(posedge clk) begin
//     dout      <= mem[addr];
//   end
// endmodule

// module bootrom (
//     input   wire           clk,
//     input   wire    [2:0]  addr,
//     output  reg     [15:0] dout
// );
//   always @(posedge clk)
//     case (addr)
// `include "compiler/build/nuc.v"
//     endcase
// 
// endmodule

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
  wire [15:0] io_din;
  wire [15:0] mem_din = 16'd0000;
  wire [12:0] code_addr;
  wire [15:0] insn;

  always @(posedge clk)
    case (code_addr[3:0])
    // 0: insn <= 16'h8001;
    // 1: insn <= 16'h6203;
    // 2: insn <= 16'h6040;
    // 3: insn <= 16'h0000;

    // 0: insn <= 16'h804A;
    // 1: insn <= 16'h8001;
    // 2: insn <= 16'h6043;
    // 3: insn <= 16'h6103;
    // 4: insn <= 16'h0000;
    // 5: insn <= 16'h608C;
    // 6: insn <= 16'h0000;
    // 7: insn <= 16'h0000;

// 3'd0: insn <= 16'h0001;
// 3'd1: insn <= 16'h8040;
// 3'd2: insn <= 16'h8001;
// 3'd3: insn <= 16'h6043;
// 3'd4: insn <= 16'h6103;
// 3'd5: insn <= 16'h0001;
// 3'd6: insn <= 16'hxxxx;
// 3'd7: insn <= 16'hxxxx;

`include "compiler/build/nuc.v"
    endcase

  // bootrom pm(.clk(clk), .addr(code_addr[2:0]), .dout(insn));

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

  reg  io_wr_;
  reg [15:0] dout_;
  always @(posedge clk)
    {io_wr_, dout_} <= {io_wr, dout};

  assign {D1,D2,D3,D4,D5} = code_addr[4:0];
  assign J3_10 = io_wr;

  wire uart0_valid, uart0_busy;
  wire [7:0] uart0_data;
  wire uart0_rd = 0, uart0_wr = io_wr;
  reg [31:0] uart_baud = 32'd9600;
  wire UART0_RX;
  buart #(.CLKFREQ(MHZ * 1000000)) _uart0 (
     .clk(clk),
     .resetq(1'b1),
     .baud(uart_baud),
     .rx(RXD),
     .tx(TXD),
     .rd(uart0_rd),
     .wr(io_wr_),
     .valid(uart0_valid),
     .busy(uart0_busy),
     .tx_data(dout_[7:0]),
     .rx_data(uart0_data));


  assign io_din = {15'd0, !uart0_busy};

endmodule // top
