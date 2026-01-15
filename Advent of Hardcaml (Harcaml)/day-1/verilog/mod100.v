module mod100 (
    rst,
    clk,
    data_in,
    rot_by
);

    input rst;
    input clk;
    input [31:0] data_in;
    output [7:0] rot_by;

    wire [31:0] _27;
    wire [31:0] _23;
    wire [95:0] _18;
    wire [63:0] _16;
    wire [95:0] _17;
    reg [95:0] _19;
    wire [31:0] _20;
    reg [31:0] _22;
    wire [63:0] _24;
    wire _2;
    wire _4;
    wire [31:0] _6;
    reg [31:0] _10;
    reg [31:0] _12;
    reg [31:0] _14;
    wire [63:0] _15;
    wire [63:0] _25;
    wire [31:0] _26;
    reg [31:0] _28;
    wire [7:0] _29;
    assign _27 = 32'b00000000000000000000000000000000;
    assign _23 = 32'b00000000000000000000000001100100;
    assign _18 = 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    assign _16 = 64'b0000000000000000000000000000000000000010100011110101110000101001;
    assign _17 = _10 * _16;
    always @(posedge _4) begin
        if (_2)
            _19 <= _18;
        else
            _19 <= _17;
    end
    assign _20 = _19[63:32];
    always @(posedge _4) begin
        if (_2)
            _22 <= _27;
        else
            _22 <= _20;
    end
    assign _24 = _22 * _23;
    assign _2 = rst;
    assign _4 = clk;
    assign _6 = data_in;
    always @(posedge _4) begin
        if (_2)
            _10 <= _27;
        else
            _10 <= _6;
    end
    always @(posedge _4) begin
        if (_2)
            _12 <= _27;
        else
            _12 <= _10;
    end
    always @(posedge _4) begin
        if (_2)
            _14 <= _27;
        else
            _14 <= _12;
    end
    assign _15 = { _27,
                   _14 };
    assign _25 = _15 - _24;
    assign _26 = _25[31:0];
    always @(posedge _4) begin
        if (_2)
            _28 <= _27;
        else
            _28 <= _26;
    end
    assign _29 = _28[7:0];
    assign rot_by = _29;

endmodule
module mod100_top (
    data_in,
    rst,
    clk,
    rot_by
);

    input [31:0] data_in;
    input rst;
    input clk;
    output [7:0] rot_by;

    wire [31:0] _2;
    wire _4;
    wire _6;
    wire [7:0] _9;
    wire [7:0] _7;
    assign _2 = data_in;
    assign _4 = rst;
    assign _6 = clk;
    mod100
        mod100
        ( .clk(_6),
          .rst(_4),
          .data_in(_2),
          .rot_by(_9[7:0]) );
    assign _7 = _9;
    assign rot_by = _7;

endmodule

