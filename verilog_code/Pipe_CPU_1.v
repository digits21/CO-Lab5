//Subject:     CO project 4 - Pipe CPU 1

module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/**** IF stage ****/
wire  [31:0]  if_mux_o;
wire  [31:0]  if_pc_o;
wire  [31:0]  if_im_o;
wire  [31:0]  if_add_o;
wire          PCSrc;

/**** ID stage ****/
wire  [31:0]  ifid_add_o;
wire  [31:0]  ifid_im_o;
wire  [31:0]  id_rf_o1;
wire  [31:0]  id_rf_o2;
wire  [31:0]  id_se_o;
wire          id_control_rw_o;
wire          id_control_regdst_o;
wire		  id_control_memread_o;
wire		  id_control_memwrite_o;
wire		  id_control_memtoreg_o;
wire          id_control_alusrc_o;
wire          id_control_branch_o;
wire		  id_control_jump_o;
wire  [2:0]   id_control_aluop_o;

/**** EX stage ****/
wire          idex_rw_o;
wire          idex_regdst_o;
wire		  idex_memread_o;
wire		  idex_memwrite_o;
wire		  idex_memtoreg_o;
wire          idex_alusrc_o;
wire          idex_branch_o;
wire		  idex_jump_o;
wire  [2:0]   idex_aluop_o;
wire  [31:0]  idex_add_o;
wire  [31:0]  idex_rf_o1;
wire  [31:0]  idex_rf_o2;
wire  [31:0]  idex_se_o;
wire  [4:0]   idex_im_o0;
wire  [4:0]   idex_im_o1;
wire  [31:0]  ex_sl2_o;
wire  [31:0]  ex_add_o;
wire  [31:0]  ex_mux0_o;
wire  [4:0]   ex_mux1_o;
wire  [3:0]   ex_alu_control_o;
wire  [31:0]  ex_alu_result_o;
wire 		  ex_alu_zero_o;

/**** MEM stage ****/
wire          exmem_rw_o;
wire		  exmem_jump_o;
wire		  exmem_memread_o;
wire		  exmem_memwrite_o;
wire		  exmem_memtoreg_o;
wire          exmem_branch_o;
wire  [31:0]  exmem_alu_result_o;
wire 		  exmem_alu_zero_o;
wire  [31:0]  exmem_add_o;
wire  [31:0]  exmem_rf_o2;
wire  [4:0]   exmem_mux1_o;
wire  [31:0]  mem_dm_o;

/**** WB stage ****/
wire  [31:0]  wb_mux_o;
wire  [4:0]   memwb_mux1_o;
wire          memwb_rw_o;
wire		  memwb_memtoreg_o;
wire  [31:0]  memwb_alu_result_o;
wire  [31:0]  memwb_dm_o;


/**** IF stage ****/
MUX_2to1 #(.size(32)) IF_MUX(
    .data0_i(if_add_o),
    .data1_i(exmem_add_o),
    .select_i(PCSrc),
    .data_o(if_mux_o)
		);	
ProgramCounter PC(
    .clk_i(clk_i),
	.rst_i (rst_i),
    //.stall_i(1'b0),
	.pc_in_i(if_mux_o),
	.pc_out_o(if_pc_o)	
		);
Adder IF_ADD(
	.src1_i(if_pc_o),     
	.src2_i(32'd4),     
	.sum_o(if_add_o)    
		);
Instruction_Memory IM(
    .addr_i(if_pc_o),
    .instr_o(if_im_o)
		);
Pipe_Reg #(.size(64)) IF_ID(       
	.clk_i(clk_i),  
	.rst_i(rst_i), 
	.data_i({if_add_o, if_im_o}),
	.data_o({ifid_add_o, ifid_im_o})
		);		

/**** ID stage ****/
Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i) ,     
    .RSaddr_i(ifid_im_o[25:21]) ,  
    .RTaddr_i(ifid_im_o[20:16]) ,  
    .RDaddr_i(memwb_mux1_o),  
    .RDdata_i(wb_mux_o), 
    .RegWrite_i(memwb_rw_o),
    .RSdata_o(id_rf_o1),  
    .RTdata_o(id_rf_o2)   
		);
Decoder Control(
        .instr_op_i(ifid_im_o[31:26]),
        .RegWrite_o(id_control_rw_o),
        .ALU_op_o(id_control_aluop_o),
        .ALUSrc_o(id_control_alusrc_o),
        .RegDst_o(id_control_regdst_o),
        .Branch_o(id_control_branch_o),
        .Jump_o(id_control_jump_o),
        .MemRead_o(id_control_memread_o),
        .MemWrite_o(id_control_memwrite_o),
        .MemtoReg_o(id_control_memtoreg_o)
        );
Sign_Extend Sign_Extend(
        .data_i(ifid_im_o[15:0]),
        .data_o(id_se_o)
        );
Pipe_Reg #(.size(149)) ID_EX(       
	.clk_i(clk_i),  
	.rst_i(rst_i), 
	.data_i({id_control_rw_o, id_control_aluop_o, id_control_alusrc_o, id_control_regdst_o,
             id_control_branch_o, id_control_jump_o, id_control_memread_o, id_control_memwrite_o,
             id_control_memtoreg_o, ifid_add_o, id_rf_o1, id_rf_o2, id_se_o, ifid_im_o[20:16],
             ifid_im_o[15:11]}),
	.data_o({idex_rw_o, idex_aluop_o, idex_alusrc_o, idex_regdst_o,
             idex_branch_o, idex_jump_o, idex_memread_o, idex_memwrite_o,
             idex_memtoreg_o, idex_add_o, idex_rf_o1, idex_rf_o2, idex_se_o, idex_im_o0,
             idex_im_o1})
		);		

/**** EX stage ****/
Shift_Left_Two_32 EX_SL2(
        .data_i(idex_se_o),
        .data_o(ex_sl2_o)
        ); 
Adder EX_ADD(
        .src1_i(idex_add_o),     
	    .src2_i(ex_sl2_o),     
	    .sum_o(ex_add_o)      
	    );
MUX_2to1 #(.size(32)) EX_MUX0(
		.data0_i(idex_rf_o2),
        .data1_i(idex_se_o),
        .select_i(idex_alusrc_o),
        .data_o(ex_mux0_o)
        );
ALU_Ctrl ALU_Control(
		.funct_i(idex_se_o[5:0]),   
        .ALUOp_i(idex_aluop_o),
        .ALUCtrl_o(ex_alu_control_o)
		);
ALU ALU(
		.src1(idex_rf_o1),
	    .src2(ex_mux0_o),
	    .ALU_control(ex_alu_control_o),
	    .result(ex_alu_result_o),
		.zero(ex_alu_zero_o)
		);
MUX_2to1 #(.size(5)) EX_MUX1(
		.data0_i(idex_im_o0),
        .data1_i(idex_im_o1),
        .select_i(idex_regdst_o),
        .data_o(ex_mux1_o)
        );
Pipe_Reg #(.size(108)) EX_MEM(       
	.clk_i(clk_i),  
	.rst_i(rst_i), 
    .data_i({idex_rw_o, idex_jump_o, idex_memread_o,
             idex_memwrite_o, idex_memtoreg_o, idex_branch_o,
             ex_add_o, ex_alu_zero_o, ex_alu_result_o,
             idex_rf_o2, ex_mux1_o}),
    .data_o({exmem_rw_o, exmem_jump_o, exmem_memread_o, 
             exmem_memwrite_o, exmem_memtoreg_o, exmem_branch_o,
             exmem_add_o, exmem_alu_zero_o, exmem_alu_result_o,
             exmem_rf_o2, exmem_mux1_o})
		);		

/**** MEM stage ****/
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(exmem_alu_result_o),
		.data_i(exmem_rf_o2),
		.MemRead_i(exmem_memread_o),
		.MemWrite_i(exmem_memwrite_o),
		.data_o(mem_dm_o)
	    );
Pipe_Reg #(.size(71)) MEM_WB(
        .clk_i(clk_i),
		.rst_i (rst_i),
		.data_i({exmem_rw_o, exmem_memtoreg_o, mem_dm_o, exmem_alu_result_o, exmem_mux1_o}),
		.data_o({memwb_rw_o, memwb_memtoreg_o, memwb_dm_o, memwb_alu_result_o, memwb_mux1_o})
		);

/**** WB stage ****/
MUX_2to1 #(.size(32)) WB_MUX(
        .data0_i(memwb_alu_result_o),
		.data1_i(memwb_dm_o),
        .select_i(memwb_memtoreg_o),
        .data_o(wb_mux_o)
        );

/**** ****/
assign PCSrc = exmem_alu_zero_o & exmem_branch_o;

endmodule
