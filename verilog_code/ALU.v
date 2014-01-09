//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU(
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero          // 1 bit when the output is 0, zero must be set (output)
           );

input  [32-1:0] src1;
input  [32-1:0] src2;
input  [4-1:0]  ALU_control;

output [32-1:0] result;
output          zero;

reg    [32-1:0] result;
assign zero = (result == 0);

always @(*)
begin
	case(ALU_control)
		4'b0000: begin
			result <= src1 & src2;
		end
		4'b0001: begin
			result <= src1 | src2;
		end
		4'b0010: begin
			result <= src1 + src2;
		end
		4'b0110: begin
			result <= src1 - src2;
		end
		4'b0111: begin
			result <= src1 < src2 ? 1 : 0;
		end
		4'b1000: begin
			result <= src2 << src1;	// shift reg
		end
		4'b1001: begin			// shift immediate
			result <= src2 << 16;
		end
		4'b1011: begin			//mul
			result <= src2 * src1;
		end
		
		default:begin
			result <= 0;
		end
	endcase
end

endmodule
