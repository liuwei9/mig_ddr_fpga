`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/08 21:29:44
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
 input c0_sys_clk_p,
 input c0_sys_clk_n, 
 input sys_rst,    
 output wire [16 : 0] c0_ddr4_adr ,   
 output wire [1 : 0] c0_ddr4_ba ,     
 output wire [0 : 0] c0_ddr4_cke ,    
 output wire [0 : 0] c0_ddr4_cs_n ,   
 inout wire [7 : 0] c0_ddr4_dm_dbi_n ,
 inout wire [63 : 0] c0_ddr4_dq ,     
 inout wire [7 : 0] c0_ddr4_dqs_c ,   
 inout wire [7 : 0] c0_ddr4_dqs_t,    
 output wire [0 : 0] c0_ddr4_odt,     
 output wire [0 : 0] c0_ddr4_bg ,     
 output wire c0_ddr4_reset_n ,        
 output wire c0_ddr4_act_n   ,        
 output wire [0 : 0] c0_ddr4_ck_c ,   
 output wire [0 : 0] c0_ddr4_ck_t    

    );


localparam ADDR_WIDTH = 5'd28;
localparam DATA_WIDTH = 10'd512;
 wire c0_ddr4_ui_clk                ;
 wire c0_ddr4_ui_clk_sync_rst       ;
 wire c0_ddr4_app_en                 ;
 wire c0_ddr4_app_wdf_end            ;
 wire c0_ddr4_app_wdf_wren           ;
 wire c0_ddr4_app_rd_data_end       ;
 wire c0_ddr4_app_rd_data_valid     ;
 wire c0_ddr4_app_rdy               ;
 wire c0_ddr4_app_wdf_rdy           ;
 wire [ADDR_WIDTH - 1'b1 : 0] c0_ddr4_app_addr      ;
 wire [2 : 0] c0_ddr4_app_cmd        ;
 wire [DATA_WIDTH - 1'b1 : 0] c0_ddr4_app_wdf_data ;
 wire [DATA_WIDTH - 1'b1 : 0] c0_ddr4_app_rd_data ;

localparam CMD_WRITE = 3'b000;
localparam CMD_READ = 3'b001;

localparam IDLE = 2'b00;
localparam WRITE = 2'b01;
localparam WAIT = 2'b10;
localparam READ = 2'b11;
reg [1:0] state;

reg [DATA_WIDTH - 1'b1 : 0] data;
reg [ADDR_WIDTH - 1'b1 : 0] addr;

assign c0_ddr4_app_cmd = (state == WRITE) ? CMD_WRITE : CMD_READ;
assign c0_ddr4_app_en = (state == WRITE) ? (c0_ddr4_app_wdf_rdy & c0_ddr4_app_rdy) : ((state == READ) & c0_ddr4_app_rdy);
assign c0_ddr4_app_wdf_wren = (state == WRITE) ? (c0_ddr4_app_wdf_rdy & c0_ddr4_app_rdy) : 1'b0;
assign c0_ddr4_app_wdf_end = c0_ddr4_app_wdf_wren;
assign c0_ddr4_app_addr = addr;
assign c0_ddr4_app_wdf_data = data;

localparam TEST_DATA_RANGE = 10'd1000;

always @(posedge c0_ddr4_ui_clk) begin
	if (c0_ddr4_ui_clk_sync_rst | !c0_init_calib_complete) begin
		// reset
		state <= IDLE;
		data <= 512'd0;
		addr <= 28'd0;
		
	end
	else begin
		case (state)
			IDLE:begin
				state <= WRITE;
				addr <= 28'd0;
				data <= 512'd0;
			end
			WRITE:begin
				state <= (TEST_DATA_RANGE == data && c0_ddr4_app_wdf_rdy && c0_ddr4_app_rdy) ? WAIT : state;
				addr <= (c0_ddr4_app_wdf_rdy & c0_ddr4_app_rdy) ? (addr + 4'd8) : addr;
				data <= (c0_ddr4_app_rdy & c0_ddr4_app_wdf_rdy) ? (data + 1'b1) : data;
			end
			WAIT:begin
				state <= READ;
				addr <= 28'd0;
				data <= 512'd0;
			end
			READ:begin
				state <=(TEST_DATA_RANGE == data && c0_ddr4_app_rdy) ? IDLE : state;
				addr <= (c0_ddr4_app_rdy) ? (addr + 4'd8) : addr;
				data <= (c0_ddr4_app_rdy) ? (data + 1'b1) : data;
			end
		endcase
	end
end


    ddr4_0 ddr4_inst (
  .c0_init_calib_complete(c0_init_calib_complete),        // output wire c0_init_calib_complete
  .dbg_clk(dbg_clk),                                      // output wire dbg_clk
  .c0_sys_clk_p(c0_sys_clk_p),                            // input wire c0_sys_clk_p
  .c0_sys_clk_n(c0_sys_clk_n),                            // input wire c0_sys_clk_n
  .dbg_bus(dbg_bus),                                      // output wire [511 : 0] dbg_bus
  .c0_ddr4_adr(c0_ddr4_adr),                              // output wire [16 : 0] c0_ddr4_adr
  .c0_ddr4_ba(c0_ddr4_ba),                                // output wire [1 : 0] c0_ddr4_ba
  .c0_ddr4_cke(c0_ddr4_cke),                              // output wire [0 : 0] c0_ddr4_cke
  .c0_ddr4_cs_n(c0_ddr4_cs_n),                            // output wire [0 : 0] c0_ddr4_cs_n
  .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n),                    // inout wire [7 : 0] c0_ddr4_dm_dbi_n
  .c0_ddr4_dq(c0_ddr4_dq),                                // inout wire [63 : 0] c0_ddr4_dq
  .c0_ddr4_dqs_c(c0_ddr4_dqs_c),                          // inout wire [7 : 0] c0_ddr4_dqs_c
  .c0_ddr4_dqs_t(c0_ddr4_dqs_t),                          // inout wire [7 : 0] c0_ddr4_dqs_t
  .c0_ddr4_odt(c0_ddr4_odt),                              // output wire [0 : 0] c0_ddr4_odt
  .c0_ddr4_bg(c0_ddr4_bg),                                // output wire [0 : 0] c0_ddr4_bg
  .c0_ddr4_reset_n(c0_ddr4_reset_n),                      // output wire c0_ddr4_reset_n
  .c0_ddr4_act_n(c0_ddr4_act_n),                          // output wire c0_ddr4_act_n
  .c0_ddr4_ck_c(c0_ddr4_ck_c),                            // output wire [0 : 0] c0_ddr4_ck_c
  .c0_ddr4_ck_t(c0_ddr4_ck_t),                            // output wire [0 : 0] c0_ddr4_ck_t
  .c0_ddr4_ui_clk(c0_ddr4_ui_clk),                        // output wire c0_ddr4_ui_clk
  .c0_ddr4_ui_clk_sync_rst(c0_ddr4_ui_clk_sync_rst),      // output wire c0_ddr4_ui_clk_sync_rst
  .c0_ddr4_app_en(c0_ddr4_app_en),                        // input wire c0_ddr4_app_en
  .c0_ddr4_app_hi_pri(1'b0),                // input wire c0_ddr4_app_hi_pri
  .c0_ddr4_app_wdf_end(c0_ddr4_app_wdf_end),              // input wire c0_ddr4_app_wdf_end
  .c0_ddr4_app_wdf_wren(c0_ddr4_app_wdf_wren),            // input wire c0_ddr4_app_wdf_wren
  .c0_ddr4_app_rd_data_end(c0_ddr4_app_rd_data_end),      // output wire c0_ddr4_app_rd_data_end
  .c0_ddr4_app_rd_data_valid(c0_ddr4_app_rd_data_valid),  // output wire c0_ddr4_app_rd_data_valid
  .c0_ddr4_app_rdy(c0_ddr4_app_rdy),                      // output wire c0_ddr4_app_rdy
  .c0_ddr4_app_wdf_rdy(c0_ddr4_app_wdf_rdy),              // output wire c0_ddr4_app_wdf_rdy
  .c0_ddr4_app_addr(c0_ddr4_app_addr),                    // input wire [27 : 0] c0_ddr4_app_addr
  .c0_ddr4_app_cmd(c0_ddr4_app_cmd),                      // input wire [2 : 0] c0_ddr4_app_cmd
  .c0_ddr4_app_wdf_data(c0_ddr4_app_wdf_data),            // input wire [511 : 0] c0_ddr4_app_wdf_data
  .c0_ddr4_app_wdf_mask(64'b0),            // input wire [63 : 0] c0_ddr4_app_wdf_mask
  .c0_ddr4_app_rd_data(c0_ddr4_app_rd_data),              // output wire [511 : 0] c0_ddr4_app_rd_data
  .sys_rst(sys_rst)                                      // input wire sys_rst
);
endmodule
