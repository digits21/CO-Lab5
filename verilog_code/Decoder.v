//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   Jump_o;
output		   MemRead_o;
output		   MemWrite_o;
output		   MemtoReg_o;
//Internal Signals
reg [3-1:0]    ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg			   Jump_o;
reg			   MemRead_o;
reg			   MemWrite_o;
reg 		   MemtoReg_o;

//Parameter


//Main function
always@(*)
begin
	case(instr_op_i)
		6'b000000: begin	//R-type op-field=0
			RegDst_o <= 1;
			ALUSrc_o <= 0;
			RegWrite_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			Jump_o <= 0;
			Branch_o <= 0;
			ALU_op_o <= 3'b010;
		end
		6'b001000: begin	//I-type op-field=8
			RegDst_o <= 0;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			Jump_o <= 0;
			Branch_o <= 0;
			ALU_op_o <= 3'b000;
		end
		6'b001010: begin	//SLT Immediate
			RegDst_o <= 0;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			Jump_o <= 0;
			Branch_o <= 0;
			ALU_op_o <= 3'b001;
		end
		6'b001111: begin	//Load Upper Immediate op_field=15
			RegDst_o <= 0;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			Jump_o <= 0;
			Branch_o <= 0;
			ALU_op_o <= 3'b100;
		end
		6'b000100: begin	//beq
			RegDst_o <= RegDst_o;
			ALUSrc_o <= 0;
			RegWrite_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			Jump_o <= 0;
			Branch_o <= 1;
			ALU_op_o <= 3'b001;
		end
		6'b100011: begin		// load word
			RegDst_o <= 0;
			ALUSrc_o <= 1;
			RegWrite_o <= 1;
			MemRead_o <= 1;
			MemWrite_o <= 0;
			MemtoReg_o <= 1;
			Jump_o <= 0;
			Branch_o <= 0;
			ALU_op_o <= 3'b000;
		end
		6'b101011: begin		// save word
			RegDst_o <= RegDst_o;
			ALUSrc_o <= 1;
			RegWrite_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 1;
			MemtoReg_o <= MemtoReg_o;
			Jump_o <= 0;
			Branch_o <= 0;
			ALU_op_o <= 3'b000;
		end
		6'b000010: begin		// Jump
			RegDst_o <= RegDst_o;
			ALUSrc_o <= ALUSrc_o;
			RegWrite_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= MemtoReg_o;
			Jump_o <= 1;
			Branch_o <= 0;
			ALU_op_o <= ALU_op_o;
		end
		default: begin
			RegDst_o <= RegDst_o;
			ALUSrc_o <= ALUSrc_o;
			RegWrite_o <= RegWrite_o;
			MemRead_o <= MemRead_o;
			MemWrite_o <= MemWrite_o;
			MemtoReg_o <= MemtoReg_o;
			Jump_o <= Jump_o;
			Branch_o <= Branch_o;
			ALU_op_o <= ALU_op_o;
		end
	endcase

end

endmodule
