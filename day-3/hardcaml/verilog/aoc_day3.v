module aoc_day3 (
    digit_in,
    rst,
    clk,
    digit_valid,
    sum_out,
    error
);

    input [3:0] digit_in;
    input rst;
    input clk;
    input digit_valid;
    output [63:0] sum_out;
    output error;

    wire _45;
    reg _47;
    wire [63:0] _382;
    reg [3:0] _83;
    wire [59:0] _67;
    wire [63:0] _84;
    wire [63:0] _64;
    wire [127:0] _65;
    wire [63:0] _66;
    wire [63:0] _85;
    wire [2:0] _59;
    wire _60;
    wire _61;
    wire [63:0] _63;
    wire _58;
    wire [63:0] _86;
    reg [63:0] _87;
    wire [63:0] _2;
    reg [63:0] _53;
    wire [63:0] _387;
    wire _385;
    wire _386;
    wire [63:0] _388;
    wire [2:0] _49;
    wire _377;
    wire [2:0] _378;
    wire _376;
    wire [2:0] _379;
    wire [2:0] _374;
    wire [2:0] _371;
    wire _370;
    wire [2:0] _372;
    wire [2:0] _369;
    wire [3:0] _367;
    wire _368;
    wire [2:0] _373;
    wire [4:0] _347;
    wire [4:0] _361;
    wire [4:0] _362;
    wire [4:0] _359;
    wire _356;
    wire _357;
    wire [4:0] _360;
    wire [3:0] _113;
    wire _340;
    wire _341;
    wire [3:0] _343;
    wire [3:0] _336;
    wire [3:0] _337;
    wire [3:0] _117;
    wire [3:0] _115;
    wire [2:0] _107;
    wire [2:0] _108;
    wire [2:0] _109;
    wire gnd;
    wire [3:0] _110;
    wire [3:0] _116;
    wire _118;
    wire _119;
    wire _127;
    wire _124;
    wire _121;
    wire _89;
    wire _122;
    wire _125;
    wire _128;
    wire [3:0] _129;
    wire [3:0] _3;
    reg [3:0] _82;
    wire _137;
    wire [2:0] _133;
    wire _134;
    wire _131;
    wire _130;
    wire _132;
    wire _135;
    wire _138;
    wire [3:0] _139;
    wire [3:0] _4;
    reg [3:0] _79;
    wire _147;
    wire _144;
    wire _141;
    wire _140;
    wire _142;
    wire _145;
    wire _148;
    wire [3:0] _149;
    wire [3:0] _5;
    reg [3:0] _76;
    wire _157;
    wire _154;
    wire _151;
    wire _150;
    wire _152;
    wire _155;
    wire _158;
    wire [3:0] _159;
    wire [3:0] _6;
    reg [3:0] _73;
    wire _171;
    wire _172;
    wire [3:0] _176;
    wire [3:0] _7;
    reg [3:0] _175;
    wire [3:0] _177;
    wire _178;
    wire _179;
    wire [3:0] _183;
    wire [3:0] _8;
    reg [3:0] _182;
    wire [3:0] _184;
    wire _185;
    wire _186;
    wire [3:0] _190;
    wire [3:0] _9;
    reg [3:0] _189;
    wire [3:0] _191;
    wire _192;
    wire _193;
    wire [3:0] _197;
    wire [3:0] _10;
    reg [3:0] _196;
    wire [3:0] _198;
    wire _199;
    wire _200;
    wire [3:0] _204;
    wire [3:0] _11;
    reg [3:0] _203;
    wire [3:0] _205;
    wire _206;
    wire _207;
    wire [3:0] _211;
    wire [3:0] _12;
    reg [3:0] _210;
    wire [3:0] _212;
    wire _213;
    wire _214;
    wire [3:0] _218;
    wire [3:0] _13;
    reg [3:0] _217;
    wire [3:0] _219;
    wire _220;
    wire _221;
    wire [3:0] _225;
    wire [3:0] _14;
    reg [3:0] _224;
    wire [3:0] _226;
    wire _227;
    wire _228;
    wire [3:0] _232;
    wire [3:0] _15;
    reg [3:0] _231;
    wire [3:0] _233;
    wire _234;
    wire _235;
    wire [3:0] _239;
    wire [3:0] _16;
    reg [3:0] _238;
    wire _241;
    wire _242;
    wire [3:0] _246;
    wire [3:0] _17;
    reg [3:0] _245;
    wire [3:0] _247;
    wire _248;
    wire _249;
    wire [3:0] _253;
    wire [3:0] _18;
    reg [3:0] _252;
    wire [3:0] _254;
    wire _255;
    wire _256;
    wire [3:0] _260;
    wire [3:0] _19;
    reg [3:0] _259;
    wire [3:0] _261;
    wire _262;
    wire _263;
    wire [3:0] _267;
    wire [3:0] _20;
    reg [3:0] _266;
    wire _269;
    wire _270;
    wire [3:0] _274;
    wire [3:0] _21;
    reg [3:0] _273;
    wire [3:0] _23;
    wire [3:0] _278;
    wire _276;
    wire [3:0] _280;
    wire [3:0] _281;
    wire [3:0] _24;
    reg [3:0] _169;
    wire _283;
    wire _284;
    wire [3:0] _288;
    wire [3:0] _25;
    reg [3:0] _287;
    wire [3:0] _295;
    wire _293;
    wire [3:0] _297;
    wire [3:0] _298;
    wire [3:0] _26;
    reg [3:0] _291;
    reg [3:0] _299;
    wire [3:0] _300;
    wire [3:0] _27;
    reg [3:0] _102;
    wire _308;
    wire _305;
    wire _302;
    wire _301;
    wire _303;
    wire _306;
    wire _309;
    wire [3:0] _310;
    wire [3:0] _28;
    reg [3:0] _70;
    wire [2:0] _97;
    wire [2:0] _98;
    reg [3:0] _99;
    wire _103;
    wire _104;
    wire vdd;
    wire _30;
    wire _32;
    wire [2:0] _319;
    wire _314;
    wire _315;
    wire [2:0] _317;
    wire _312;
    wire [2:0] _320;
    reg [2:0] _321;
    wire [2:0] _33;
    reg [2:0] _56;
    wire _331;
    wire _332;
    wire [2:0] _334;
    wire [2:0] _328;
    wire [2:0] _325;
    wire _323;
    wire [2:0] _326;
    wire [2:0] _329;
    reg [2:0] _335;
    wire [2:0] _34;
    reg [2:0] _93;
    wire _94;
    wire _105;
    wire _120;
    wire [3:0] _338;
    reg [3:0] _344;
    wire [3:0] _35;
    reg [3:0] _114;
    wire _352;
    wire _349;
    wire _346;
    wire _350;
    wire _353;
    wire _36;
    wire _354;
    wire _38;
    wire [4:0] _163;
    wire _164;
    wire _165;
    wire _166;
    wire _355;
    wire [4:0] _363;
    wire [4:0] _39;
    reg [4:0] _162;
    wire _348;
    wire _364;
    wire [2:0] _366;
    reg [2:0] _380;
    wire [2:0] _40;
    reg [2:0] _50;
    reg [63:0] _389;
    wire [63:0] _41;
    reg [63:0] _383;
    assign _45 = 1'b0;
    always @(posedge _32) begin
        if (_30)
            _47 <= _45;
        else
            _47 <= gnd;
    end
    assign _382 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    always @* begin
        case (_56)
        0:
            _83 <= _70;
        1:
            _83 <= _73;
        2:
            _83 <= _76;
        3:
            _83 <= _79;
        default:
            _83 <= _82;
        endcase
    end
    assign _67 = 60'b000000000000000000000000000000000000000000000000000000000000;
    assign _84 = { _67,
                   _83 };
    assign _64 = 64'b0000000000000000000000000000000000000000000000000000000000001010;
    assign _65 = _53 * _64;
    assign _66 = _65[63:0];
    assign _85 = _66 + _84;
    assign _59 = 3'b101;
    assign _60 = _56 < _59;
    assign _61 = ~ _60;
    assign _63 = _61 ? _382 : _53;
    assign _58 = _56 < _59;
    assign _86 = _58 ? _85 : _63;
    always @* begin
        case (_50)
        0:
            _87 <= _53;
        1:
            _87 <= _53;
        2:
            _87 <= _53;
        3:
            _87 <= _53;
        4:
            _87 <= _86;
        default:
            _87 <= _53;
        endcase
    end
    assign _2 = _87;
    always @(posedge _32) begin
        if (_30)
            _53 <= _382;
        else
            _53 <= _2;
    end
    assign _387 = _383 + _53;
    assign _385 = _56 < _59;
    assign _386 = ~ _385;
    assign _388 = _386 ? _387 : _383;
    assign _49 = 3'b000;
    assign _377 = ~ _348;
    assign _378 = _377 ? _107 : _49;
    assign _376 = _56 < _59;
    assign _379 = _376 ? _369 : _378;
    assign _374 = _120 ? _133 : _107;
    assign _371 = 3'b010;
    assign _370 = ~ _348;
    assign _372 = _370 ? _371 : _107;
    assign _369 = 3'b100;
    assign _367 = 4'b1111;
    assign _368 = _114 < _367;
    assign _373 = _368 ? _372 : _369;
    assign _347 = 5'b00000;
    assign _361 = 5'b00001;
    assign _362 = _162 + _361;
    assign _359 = _162 - _361;
    assign _356 = ~ _166;
    assign _357 = _356 & _36;
    assign _360 = _357 ? _359 : _162;
    assign _113 = 4'b0000;
    assign _340 = _56 < _59;
    assign _341 = ~ _340;
    assign _343 = _341 ? _113 : _114;
    assign _336 = 4'b0001;
    assign _337 = _114 + _336;
    assign _117 = 4'b0101;
    assign _115 = _367 - _114;
    assign _107 = 3'b001;
    assign _108 = _93 - _107;
    assign _109 = _94 ? _108 : _49;
    assign gnd = 1'b0;
    assign _110 = { gnd,
                    _109 };
    assign _116 = _110 + _115;
    assign _118 = _116 < _117;
    assign _119 = ~ _118;
    assign _127 = _93 < _59;
    assign _124 = _93 == _369;
    assign _121 = ~ _120;
    assign _89 = _50 == _133;
    assign _122 = _89 & _121;
    assign _125 = _122 & _124;
    assign _128 = _125 & _127;
    assign _129 = _128 ? _102 : _82;
    assign _3 = _129;
    always @(posedge _32) begin
        if (_30)
            _82 <= _113;
        else
            _82 <= _3;
    end
    assign _137 = _93 < _59;
    assign _133 = 3'b011;
    assign _134 = _93 == _133;
    assign _131 = ~ _120;
    assign _130 = _50 == _133;
    assign _132 = _130 & _131;
    assign _135 = _132 & _134;
    assign _138 = _135 & _137;
    assign _139 = _138 ? _102 : _79;
    assign _4 = _139;
    always @(posedge _32) begin
        if (_30)
            _79 <= _113;
        else
            _79 <= _4;
    end
    assign _147 = _93 < _59;
    assign _144 = _93 == _371;
    assign _141 = ~ _120;
    assign _140 = _50 == _133;
    assign _142 = _140 & _141;
    assign _145 = _142 & _144;
    assign _148 = _145 & _147;
    assign _149 = _148 ? _102 : _76;
    assign _5 = _149;
    always @(posedge _32) begin
        if (_30)
            _76 <= _113;
        else
            _76 <= _5;
    end
    assign _157 = _93 < _59;
    assign _154 = _93 == _107;
    assign _151 = ~ _120;
    assign _150 = _50 == _133;
    assign _152 = _150 & _151;
    assign _155 = _152 & _154;
    assign _158 = _155 & _157;
    assign _159 = _158 ? _102 : _73;
    assign _6 = _159;
    always @(posedge _32) begin
        if (_30)
            _73 <= _113;
        else
            _73 <= _6;
    end
    assign _171 = _169 == _367;
    assign _172 = _166 & _171;
    assign _176 = _172 ? _23 : _175;
    assign _7 = _176;
    always @(posedge _32) begin
        if (_30)
            _175 <= _113;
        else
            _175 <= _7;
    end
    assign _177 = 4'b1110;
    assign _178 = _169 == _177;
    assign _179 = _166 & _178;
    assign _183 = _179 ? _23 : _182;
    assign _8 = _183;
    always @(posedge _32) begin
        if (_30)
            _182 <= _113;
        else
            _182 <= _8;
    end
    assign _184 = 4'b1101;
    assign _185 = _169 == _184;
    assign _186 = _166 & _185;
    assign _190 = _186 ? _23 : _189;
    assign _9 = _190;
    always @(posedge _32) begin
        if (_30)
            _189 <= _113;
        else
            _189 <= _9;
    end
    assign _191 = 4'b1100;
    assign _192 = _169 == _191;
    assign _193 = _166 & _192;
    assign _197 = _193 ? _23 : _196;
    assign _10 = _197;
    always @(posedge _32) begin
        if (_30)
            _196 <= _113;
        else
            _196 <= _10;
    end
    assign _198 = 4'b1011;
    assign _199 = _169 == _198;
    assign _200 = _166 & _199;
    assign _204 = _200 ? _23 : _203;
    assign _11 = _204;
    always @(posedge _32) begin
        if (_30)
            _203 <= _113;
        else
            _203 <= _11;
    end
    assign _205 = 4'b1010;
    assign _206 = _169 == _205;
    assign _207 = _166 & _206;
    assign _211 = _207 ? _23 : _210;
    assign _12 = _211;
    always @(posedge _32) begin
        if (_30)
            _210 <= _113;
        else
            _210 <= _12;
    end
    assign _212 = 4'b1001;
    assign _213 = _169 == _212;
    assign _214 = _166 & _213;
    assign _218 = _214 ? _23 : _217;
    assign _13 = _218;
    always @(posedge _32) begin
        if (_30)
            _217 <= _113;
        else
            _217 <= _13;
    end
    assign _219 = 4'b1000;
    assign _220 = _169 == _219;
    assign _221 = _166 & _220;
    assign _225 = _221 ? _23 : _224;
    assign _14 = _225;
    always @(posedge _32) begin
        if (_30)
            _224 <= _113;
        else
            _224 <= _14;
    end
    assign _226 = 4'b0111;
    assign _227 = _169 == _226;
    assign _228 = _166 & _227;
    assign _232 = _228 ? _23 : _231;
    assign _15 = _232;
    always @(posedge _32) begin
        if (_30)
            _231 <= _113;
        else
            _231 <= _15;
    end
    assign _233 = 4'b0110;
    assign _234 = _169 == _233;
    assign _235 = _166 & _234;
    assign _239 = _235 ? _23 : _238;
    assign _16 = _239;
    always @(posedge _32) begin
        if (_30)
            _238 <= _113;
        else
            _238 <= _16;
    end
    assign _241 = _169 == _117;
    assign _242 = _166 & _241;
    assign _246 = _242 ? _23 : _245;
    assign _17 = _246;
    always @(posedge _32) begin
        if (_30)
            _245 <= _113;
        else
            _245 <= _17;
    end
    assign _247 = 4'b0100;
    assign _248 = _169 == _247;
    assign _249 = _166 & _248;
    assign _253 = _249 ? _23 : _252;
    assign _18 = _253;
    always @(posedge _32) begin
        if (_30)
            _252 <= _113;
        else
            _252 <= _18;
    end
    assign _254 = 4'b0011;
    assign _255 = _169 == _254;
    assign _256 = _166 & _255;
    assign _260 = _256 ? _23 : _259;
    assign _19 = _260;
    always @(posedge _32) begin
        if (_30)
            _259 <= _113;
        else
            _259 <= _19;
    end
    assign _261 = 4'b0010;
    assign _262 = _169 == _261;
    assign _263 = _166 & _262;
    assign _267 = _263 ? _23 : _266;
    assign _20 = _267;
    always @(posedge _32) begin
        if (_30)
            _266 <= _113;
        else
            _266 <= _20;
    end
    assign _269 = _169 == _336;
    assign _270 = _166 & _269;
    assign _274 = _270 ? _23 : _273;
    assign _21 = _274;
    always @(posedge _32) begin
        if (_30)
            _273 <= _113;
        else
            _273 <= _21;
    end
    assign _23 = digit_in;
    assign _278 = _169 + _336;
    assign _276 = _169 == _367;
    assign _280 = _276 ? _113 : _278;
    assign _281 = _166 ? _280 : _169;
    assign _24 = _281;
    always @(posedge _32) begin
        if (_30)
            _169 <= _113;
        else
            _169 <= _24;
    end
    assign _283 = _169 == _113;
    assign _284 = _166 & _283;
    assign _288 = _284 ? _23 : _287;
    assign _25 = _288;
    always @(posedge _32) begin
        if (_30)
            _287 <= _113;
        else
            _287 <= _25;
    end
    assign _295 = _291 + _336;
    assign _293 = _291 == _367;
    assign _297 = _293 ? _113 : _295;
    assign _298 = _36 ? _297 : _291;
    assign _26 = _298;
    always @(posedge _32) begin
        if (_30)
            _291 <= _113;
        else
            _291 <= _26;
    end
    always @* begin
        case (_291)
        0:
            _299 <= _287;
        1:
            _299 <= _273;
        2:
            _299 <= _266;
        3:
            _299 <= _259;
        4:
            _299 <= _252;
        5:
            _299 <= _245;
        6:
            _299 <= _238;
        7:
            _299 <= _231;
        8:
            _299 <= _224;
        9:
            _299 <= _217;
        10:
            _299 <= _210;
        11:
            _299 <= _203;
        12:
            _299 <= _196;
        13:
            _299 <= _189;
        14:
            _299 <= _182;
        default:
            _299 <= _175;
        endcase
    end
    assign _300 = _36 ? _299 : _102;
    assign _27 = _300;
    always @(posedge _32) begin
        if (_30)
            _102 <= _113;
        else
            _102 <= _27;
    end
    assign _308 = _93 < _59;
    assign _305 = _93 == _49;
    assign _302 = ~ _120;
    assign _301 = _50 == _133;
    assign _303 = _301 & _302;
    assign _306 = _303 & _305;
    assign _309 = _306 & _308;
    assign _310 = _309 ? _102 : _70;
    assign _28 = _310;
    always @(posedge _32) begin
        if (_30)
            _70 <= _113;
        else
            _70 <= _28;
    end
    assign _97 = _93 - _107;
    assign _98 = _94 ? _97 : _49;
    always @* begin
        case (_98)
        0:
            _99 <= _70;
        1:
            _99 <= _73;
        2:
            _99 <= _76;
        3:
            _99 <= _79;
        default:
            _99 <= _82;
        endcase
    end
    assign _103 = _99 < _102;
    assign _104 = _94 & _103;
    assign vdd = 1'b1;
    assign _30 = rst;
    assign _32 = clk;
    assign _319 = _56 + _107;
    assign _314 = _56 < _59;
    assign _315 = ~ _314;
    assign _317 = _315 ? _49 : _56;
    assign _312 = _56 < _59;
    assign _320 = _312 ? _319 : _317;
    always @* begin
        case (_50)
        0:
            _321 <= _56;
        1:
            _321 <= _56;
        2:
            _321 <= _56;
        3:
            _321 <= _56;
        4:
            _321 <= _320;
        default:
            _321 <= _56;
        endcase
    end
    assign _33 = _321;
    always @(posedge _32) begin
        if (_30)
            _56 <= _49;
        else
            _56 <= _33;
    end
    assign _331 = _56 < _59;
    assign _332 = ~ _331;
    assign _334 = _332 ? _49 : _93;
    assign _328 = _93 - _107;
    assign _325 = _93 + _107;
    assign _323 = _93 < _59;
    assign _326 = _323 ? _325 : _93;
    assign _329 = _120 ? _328 : _326;
    always @* begin
        case (_50)
        0:
            _335 <= _93;
        1:
            _335 <= _93;
        2:
            _335 <= _93;
        3:
            _335 <= _329;
        4:
            _335 <= _334;
        default:
            _335 <= _93;
        endcase
    end
    assign _34 = _335;
    always @(posedge _32) begin
        if (_30)
            _93 <= _49;
        else
            _93 <= _34;
    end
    assign _94 = _49 < _93;
    assign _105 = _94 & _104;
    assign _120 = _105 & _119;
    assign _338 = _120 ? _114 : _337;
    always @* begin
        case (_50)
        0:
            _344 <= _114;
        1:
            _344 <= _114;
        2:
            _344 <= _114;
        3:
            _344 <= _338;
        4:
            _344 <= _343;
        default:
            _344 <= _114;
        endcase
    end
    assign _35 = _344;
    always @(posedge _32) begin
        if (_30)
            _114 <= _113;
        else
            _114 <= _35;
    end
    assign _352 = _114 < _367;
    assign _349 = ~ _348;
    assign _346 = _50 == _107;
    assign _350 = _346 & _349;
    assign _353 = _350 & _352;
    assign _36 = _353;
    assign _354 = ~ _36;
    assign _38 = digit_valid;
    assign _163 = 5'b10000;
    assign _164 = _162 == _163;
    assign _165 = ~ _164;
    assign _166 = _165 & _38;
    assign _355 = _166 & _354;
    assign _363 = _355 ? _362 : _360;
    assign _39 = _363;
    always @(posedge _32) begin
        if (_30)
            _162 <= _347;
        else
            _162 <= _39;
    end
    assign _348 = _162 == _347;
    assign _364 = ~ _348;
    assign _366 = _364 ? _107 : _49;
    always @* begin
        case (_50)
        0:
            _380 <= _366;
        1:
            _380 <= _373;
        2:
            _380 <= _133;
        3:
            _380 <= _374;
        4:
            _380 <= _379;
        default:
            _380 <= _50;
        endcase
    end
    assign _40 = _380;
    always @(posedge _32) begin
        if (_30)
            _50 <= _49;
        else
            _50 <= _40;
    end
    always @* begin
        case (_50)
        0:
            _389 <= _383;
        1:
            _389 <= _383;
        2:
            _389 <= _383;
        3:
            _389 <= _383;
        4:
            _389 <= _388;
        default:
            _389 <= _383;
        endcase
    end
    assign _41 = _389;
    always @(posedge _32) begin
        if (_30)
            _383 <= _382;
        else
            _383 <= _41;
    end
    assign sum_out = _383;
    assign error = _47;

endmodule
