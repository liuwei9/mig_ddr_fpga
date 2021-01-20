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
   output                       tg_compare_error,
// output                       breath_light,
   output                       init_calib_complete
    );
    
    
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

    .app_sr_req                     (app_sr_req),  // input			app_sr_req

    .app_ref_req                    (app_ref_req),  // input			app_ref_req

    .app_zq_req                     (app_zq_req),  // input			app_zq_req

    .app_sr_active                  (app_sr_active),  // output			app_sr_active

    .app_ref_ack                    (app_ref_ack),  // output			app_ref_ack

    .app_zq_ack                     (app_zq_ack),  // output			app_zq_ack

    .ui_clk                         (ui_clk),  // output			ui_clk

    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst

    .app_wdf_mask                   (app_wdf_mask),  // input [63:0]		app_wdf_mask

    // System Clock Ports

    .sys_clk_i                       (sys_clk_i),

    .sys_rst                        (sys_rst) // input sys_rst

    );
endmodule
