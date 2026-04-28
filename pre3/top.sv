module top(
    input  logic        clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic        MemWrite
);
    logic [31:0] ReadData;

    // İşlemci ve birleşik (unified) belleğin bağlanması
    riscv rv(clk, reset, ReadData, MemWrite, DataAdr, WriteData);
    mem   memory(clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule

// Birleşik Bellek (Komutları ve Verileri aynı yerde tutar)
module mem(
    input  logic        clk, we,
    input  logic [31:0] a, wd,
    output logic [31:0] rd
);
    logic [31:0] RAM[63:0]; // 64-word (256 byte) hafıza

    // Test programının belleğe yüklenmesi
    initial $readmemh("riscvtest.txt", RAM);

    assign rd = RAM[a[31:2]]; // Word-hizalamalı okuma

    always_ff @(posedge clk)
        if (we) RAM[a[31:2]] <= wd; // Saat vuruşunda yazma
endmodule