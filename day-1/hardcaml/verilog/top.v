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
module top (
    in_data,
    rst,
    clk,
    dir_r,
    zero_count,
    curr_pos_op,
    dir_r_reg,
    zero_crossings
);

    input [31:0] in_data;
    input rst;
    input clk;
    input dir_r;
    output [31:0] zero_count;
    output [7:0] curr_pos_op;
    output [3:0] dir_r_reg;
    output [31:0] zero_crossings;

    wire [31:0] _18;
    wire [31:0] _46;
    wire [8:0] _40;
    wire gnd;
    wire [8:0] _39;
    wire [8:0] _41;
    wire [8:0] _37;
    wire _42;
    wire _43;
    wire [7:0] _33;
    wire _34;
    wire _35;
    wire [7:0] _31;
    wire _32;
    wire _36;
    wire _44;
    wire [31:0] _47;
    wire [63:0] _22;
    wire [63:0] _21;
    wire [127:0] _23;
    wire [31:0] _24;
    wire [31:0] _25;
    wire [31:0] _48;
    wire [31:0] _1;
    reg [31:0] _19;
    wire [31:0] _68;
    wire [7:0] _29;
    wire [7:0] _60;
    wire [7:0] _61;
    wire [7:0] _55;
    wire [31:0] _6;
    wire [7:0] _49;
    wire [7:0] _7;
    wire [7:0] _52;
    wire [7:0] _54;
    wire [3:0] _26;
    wire _9;
    wire _11;
    wire _13;
    wire [2:0] _50;
    wire [3:0] _51;
    wire [3:0] _14;
    reg [3:0] _27;
    wire _28;
    wire [7:0] _56;
    wire _58;
    wire _59;
    wire [7:0] _62;
    wire [7:0] _15;
    reg [7:0] _30 = 8'b00110010;
    wire _64;
    wire [31:0] _69;
    wire [31:0] _16;
    reg [31:0] _66;
    assign _18 = 32'b00000000000000000000000000000000;
    assign _46 = 32'b00000000000000000000000000000001;
    assign _40 = { gnd,
                   _7 };
    assign gnd = 1'b0;
    assign _39 = { gnd,
                   _30 };
    assign _41 = _39 + _40;
    assign _37 = 9'b001100100;
    assign _42 = _37 < _41;
    assign _43 = _42 & _35;
    assign _33 = 8'b00000000;
    assign _34 = _30 == _33;
    assign _35 = ~ _34;
    assign _31 = _30 - _7;
    assign _32 = _31[7:7];
    assign _36 = _32 & _35;
    assign _44 = _28 ? _43 : _36;
    assign _47 = _44 ? _46 : _18;
    assign _22 = 64'b0000000000000000000000000000000000000010100011110101110000101000;
    assign _21 = { _18,
                   _6 };
    assign _23 = _21 * _22;
    assign _24 = _23[63:32];
    assign _25 = _19 + _24;
    assign _48 = _25 + _47;
    assign _1 = _48;
    always @(posedge _11) begin
        if (_9)
            _19 <= _18;
        else
            _19 <= _1;
    end
    assign _68 = _66 + _46;
    assign _29 = 8'b00110010;
    assign _60 = 8'b01100100;
    assign _61 = _56 - _60;
    assign _55 = _30 + _7;
    assign _6 = in_data;
    mod100
        mod100
        ( .clk(_11),
          .rst(_9),
          .data_in(_6),
          .rot_by(_49[7:0]) );
    assign _7 = _49;
    assign _52 = _30 - _7;
    assign _54 = _52 + _60;
    assign _26 = 4'b0000;
    assign _9 = rst;
    assign _11 = clk;
    assign _13 = dir_r;
    assign _50 = _27[2:0];
    assign _51 = { _50,
                   _13 };
    assign _14 = _51;
    always @(posedge _11) begin
        if (_9)
            _27 <= _26;
        else
            _27 <= _14;
    end
    assign _28 = _27[3:3];
    assign _56 = _28 ? _55 : _54;
    assign _58 = _56 < _60;
    assign _59 = ~ _58;
    assign _62 = _59 ? _61 : _56;
    assign _15 = _62;
    always @(posedge _11 or posedge _9) begin
        if (_9)
            _30 <= _29;
        else
            _30 <= _15;
    end
    assign _64 = _30 == _33;
    assign _69 = _64 ? _68 : _66;
    assign _16 = _69;
    always @(posedge _11) begin
        if (_9)
            _66 <= _18;
        else
            _66 <= _16;
    end
    assign zero_count = _66;
    assign curr_pos_op = _30;
    assign dir_r_reg = _27;
    assign zero_crossings = _19;

endmodule
module aoc_day1_part1 (
    in_data,
    dir_r,
    rst,
    clk,
    zero_count,
    curr_pos_op,
    dir_r_reg,
    zero_crossings
);

    input [31:0] in_data;
    input dir_r;
    input rst;
    input clk;
    output [31:0] zero_count;
    output [7:0] curr_pos_op;
    output [3:0] dir_r_reg;
    output [31:0] zero_crossings;

    wire [31:0] _14;
    wire [3:0] _15;
    wire [7:0] _16;
    wire [31:0] _5;
    wire _7;
    wire _9;
    wire _11;
    wire [75:0] _13;
    wire [31:0] _17;
    assign _14 = _13[75:44];
    assign _15 = _13[43:40];
    assign _16 = _13[39:32];
    assign _5 = in_data;
    assign _7 = dir_r;
    assign _9 = rst;
    assign _11 = clk;
    top
        top
        ( .clk(_11),
          .rst(_9),
          .dir_r(_7),
          .in_data(_5),
          .zero_count(_13[31:0]),
          .curr_pos_op(_13[39:32]),
          .dir_r_reg(_13[43:40]),
          .zero_crossings(_13[75:44]) );
    assign _17 = _13[31:0];
    assign zero_count = _17;
    assign curr_pos_op = _16;
    assign dir_r_reg = _15;
    assign zero_crossings = _14;

endmodule

