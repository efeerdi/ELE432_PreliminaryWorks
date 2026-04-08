module testbench();
    logic        clk;
    logic        reset;
    logic [31:0] WriteData, DataAdr;
    logic        MemWrite;
		
  	logic [31:0] PC, Instr, SrcA, SrcB, ALUResult;
    // instantiate device to be tested
    top dut(clk, reset, WriteData, DataAdr, MemWrite);
	 
		assign PC        = dut.PC;
    assign Instr     = dut.Instr;
    assign SrcA      = dut.rvsingle.dp.SrcA;
    assign SrcB      = dut.rvsingle.dp.SrcB;
    assign ALUResult = dut.rvsingle.ALUResult;
    // initialize test
    initial begin
        reset = 1; #22; 
        reset = 0;
    end

    // generate clock to sequence tests
    always begin
        clk = 1; #5; 
        clk = 0; #5;
    end

    // check results
    always @(negedge clk) begin
        if(MemWrite) begin
            if(DataAdr === 104 && WriteData === 25) begin
                $display("Simulation succeeded");
                $stop;
            end else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end
endmodule