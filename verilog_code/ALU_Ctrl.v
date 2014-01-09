//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );

//I/O ports
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter


//Select exact operation
always@(*) 
begin
   case(ALUOp_i)
	    3'b000:  begin //lw sw
			ALUCtrl_o <= 4'b0010;
	    end
	    3'b001: begin //branch
			ALUCtrl_o <= 4'b0110;
		end
	    3'b010: begin	// R type
			case(funct_i)
				6'b100000: begin
					ALUCtrl_o <= 4'b0010; //add
				end
				6'b100010: begin
					ALUCtrl_o <= 4'b0110; //sub
				end
				6'b100100: begin
					ALUCtrl_o <= 4'b0000; //and
				end
				6'b100101: begin
					ALUCtrl_o <= 4'b0001; //or
				end
				6'b101010:begin
					ALUCtrl_o <= 4'b0111; //slt
				end
				6'b011000:begin
					ALUCtrl_o <= 4'b1011; //mul
				end
				default: begin
					ALUCtrl_o <= ALUCtrl_o;
				end
			endcase
	    end
	    default : begin 
			ALUCtrl_o <= ALUCtrl_o;
	    end
   endcase
end

endmodule
