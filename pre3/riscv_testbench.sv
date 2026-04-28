module testbench();

  logic        clk;
  logic        reset;
  logic [31:0] WriteData, DataAdr;
  logic        MemWrite;
  logic [31:0] PC, Instr, SrcA, SrcB, ALUResult;

  top dut(clk, reset, WriteData, DataAdr, MemWrite);
  
  assign PC        = dut.rv.dp.PC;
  assign Instr     = dut.rv.dp.Instr;
  assign SrcA      = dut.rv.dp.SrcA;
  assign SrcB      = dut.rv.dp.SrcB;
  assign ALUResult = dut.rv.dp.ALUResult;

  initial begin
    reset <= 1; # 22; reset <= 0;
  end

  always begin
    clk <= 1; # 5; clk <= 0; # 5;
  end


  always @(negedge clk) begin
    if(MemWrite) begin
      if(DataAdr === 104 && WriteData === 25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (DataAdr !== 96 && DataAdr !== 104) begin
        $display("Simulation failed at Address: %d", DataAdr);
        $stop;
      end
    end
  end
endmodule