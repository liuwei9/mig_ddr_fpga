`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/20 16:18:22
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
    inout [63:0]                 ddr3_dq,
    inout [7:0]                  ddr3_dqs_n,
    inout [7:0]                  ddr3_dqs_p,
    output [14:0]                ddr3_addr,
    output [2:0]                 ddr3_ba,
    output                       ddr3_ras_n,
    output                       ddr3_cas_n,
    output                       ddr3_we_n,
    output                       ddr3_reset_n,
    output [0:0]                 ddr3_ck_p,
    output [0:0]                 ddr3_ck_n,
    output [0:0]                 ddr3_cke,
    output [0:0]                 ddr3_cs_n,
    output [7:0]                 ddr3_dm,
    output [0:0]                 ddr3_odt,
    input                        sysclk_p,
    input                        sysclk_n,   
    //output                       tg_compare_error,
    output                       init_calib_complete
    );
    
    
    
    wire locked;
    wire clk_out200M;
    wire sysclk_buf;
    IBUFDS IBUFDS_inst (.O(sysclk_buf),.I(sysclk_p),.IB(sysclk_n) );
    clk_wiz_0 clk_inst
   (
    // Clock out ports
    .clk_out200M(clk_out200M),     // output clk_out200M
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(sysclk_buf));      // input clk_in1
    
    
    localparam ADDR_WIDTH = 5'd29;
    localparam APP_DATA_WIDTH = 10'd512;
    localparam [1:0] IDLE = 2'd0;
    localparam [1:0] WRITE = 2'd1;
    localparam [1:0] WAIT = 2'd2;
    localparam [1:0] READ = 2'd3;
    localparam [2:0] CMD_WRITE =3'd0;
    localparam [2:0] CMD_READ =3'd1;
    localparam [9:0] TEST_RANGE = 10'd1000;
    
    wire [ADDR_WIDTH - 1'b1:0] app_addr; 
    wire [2:0] app_cmd;
    wire app_en;
    wire [APP_DATA_WIDTH - 1'b1 : 0] app_wdf_data;
    wire app_wdf_end;
    wire app_wdf_wren;
    wire [APP_DATA_WIDTH - 1'b1 : 0] app_rd_data;
    wire app_rd_data_end;
    wire app_rd_data_valid;
    wire app_rdy;
    wire app_wdf_rdy;
    wire app_sr_active;
    wire app_ref_ack;
    wire app_zq_ack;
    wire ui_clk;
    wire ui_clk_sync_rst;
    
    reg [APP_DATA_WIDTH - 1'b1 : 0] count = 512'd0;
    reg [ADDR_WIDTH-1:0] app_addr_begin=0; 
    reg [1:0] state;
    assign app_en = (state == WRITE)? (app_rdy & app_wdf_rdy) : ((state == READ) & app_rdy);
    assign app_addr = app_addr_begin;
    assign app_cmd = (state == WRITE)? CMD_WRITE : CMD_READ;
    assign app_wdf_wren = (state == WRITE)? (app_rdy & app_wdf_rdy):1'b0;
    assign app_wdf_end = app_wdf_wren;
    assign app_wdf_data = count;
    
    always @(posedge ui_clk)begin
        if(ui_clk_sync_rst | !init_calib_complete) begin
            state <= IDLE;
            count <= 512'd0;
            app_addr_begin <= 29'd0;
        end else begin
            case (state)
                IDLE:begin
                    state <= WRITE;
                    //使用的开发板上搭载了4片Micron的DDR3 内存，共 2GB
                    //if(app_addr_begin >= 24'd16777210)
                        app_addr_begin <= 29'd0;
                    count <= 512'd0;                  
                end
                WRITE:begin
                    state <= (count == TEST_RANGE && app_rdy && app_wdf_rdy) ? WAIT : state;
                    app_addr_begin <= (app_rdy && app_wdf_rdy) ? (app_addr_begin + 4'd8) : app_addr_begin;
                    count <= (app_rdy && app_wdf_rdy) ? (count + 1'b1) : count;
                end
                WAIT:begin
                    state <= READ;
                    app_addr_begin <= 29'd0;
                    count <= 512'd0;
                end
                READ:begin
                    state <= (count == TEST_RANGE && app_rdy) ? IDLE : state;
                    app_addr_begin <= app_rdy ? (app_addr_begin + 4'd8) : app_addr_begin;
                    count <= app_rdy ? (count + 1'b1) : count;
                end
                default :begin
                    state <= IDLE;
                    app_addr_begin <= 29'd0;
                    count <= 512'd0;
                end
            endcase
        end
    end
    
    
    
    
    
    
    
     mig_7series_0 u_mig_7series_0 (

    // Memory interface ports

    .ddr3_addr                      (ddr3_addr),  // output [14:0]		ddr3_addr

    .ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba

    .ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n

    .ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]		ddr3_ck_n

    .ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]		ddr3_ck_p

    .ddr3_cke                       (ddr3_cke),  // output [0:0]		ddr3_cke

    .ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n

    .ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n

    .ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n

    .ddr3_dq                        (ddr3_dq),  // inout [63:0]		ddr3_dq

    .ddr3_dqs_n                     (ddr3_dqs_n),  // inout [7:0]		ddr3_dqs_n

    .ddr3_dqs_p                     (ddr3_dqs_p),  // inout [7:0]		ddr3_dqs_p

    .init_calib_complete            (init_calib_complete),  // output			init_calib_complete

      

	.ddr3_cs_n                      (ddr3_cs_n),  // output [0:0]		ddr3_cs_n

    .ddr3_dm                        (ddr3_dm),  // output [7:0]		ddr3_dm

    .ddr3_odt                       (ddr3_odt),  // output [0:0]		ddr3_odt

    // Application interface ports

    .app_addr                       (app_addr),  // input [28:0]		app_addr

    .app_cmd                        (app_cmd),  // input [2:0]		app_cmd

    .app_en                         (app_en),  // input				app_en

    .app_wdf_data                   (app_wdf_data),  // input [511:0]		app_wdf_data

    .app_wdf_end                    (app_wdf_end),  // input				app_wdf_end

    .app_wdf_wren                   (app_wdf_wren),  // input				app_wdf_wren

    .app_rd_data                    (app_rd_data),  // output [511:0]		app_rd_data

    .app_rd_data_end                (app_rd_data_end),  // output			app_rd_data_end

    .app_rd_data_valid              (app_rd_data_valid),  // output			app_rd_data_valid

    .app_rdy                        (app_rdy),  // output			app_rdy

    .app_wdf_rdy                    (app_wdf_rdy),  // output			app_wdf_rdy

    .app_sr_req                     (1'b0),  // input			app_sr_req

    .app_ref_req                    (1'b0),  // input			app_ref_req

    .app_zq_req                     (1'b0),  // input			app_zq_req

    .app_sr_active                  (app_sr_active),  // output			app_sr_active

    .app_ref_ack                    (app_ref_ack),  // output			app_ref_ack

    .app_zq_ack                     (app_zq_ack),  // output			app_zq_ack

    .ui_clk                         (ui_clk),  // output			ui_clk

    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst

    .app_wdf_mask                   (64'b0),  // input [63:0]		app_wdf_mask

    // System Clock Ports

    .sys_clk_i                       (clk_out200M),

    .sys_rst                        (locked) // input sys_rst

    );
endmodule
