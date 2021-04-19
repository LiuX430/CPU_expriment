
//三种状态机的书写方式，wr_req、rd_req作为输入，cmd作为输出，cstate、nstate作为状态寄存器

//一段式状态机:

module ZhuangTaiJi ()

reg [3:0]cstate;

always @(posedge clk or negedge rst_n) begin
    if(! rst_n) begin
        cstate <= IDLE;
        cmd <= 3'b111;
    end
    else begin
        case(cstate)
            IDLE: if(wr_req) begin
                    cstate <= WR_S1;
                    cmd <= 3'b011;
                end 
                else begin
                    cstate <= IDLE;
                    cmd <= 3'101;
                end
                else begin
                    cstate <= IDLE;
                    cmd <= 3'b111;
                end
            WR_S1: begin
                        cstate <= WR_S2;
                        cmd <= 3'b101;
                    end
            WR_S2: begin 
                        cstate <= IDLE;
                        cmd <= 3'b111;
                    end
            RD_S1: if(wr_req) begin
                        cstate <= WR_S2;
                        cmd <= 3'b101;
                    end
                    else begin
                        cstate <= RD_S2;
                        cmd <= 3'b110;
                    end
            RD_S2： if(wr_req) begin
                        cstate <= WR_S1;
                        cmd <= 3'b011;
                    end
                    else begin
                        cstate <= IDLE;
                        cmd <+3'b111;
                    end
            default:cstate <= IDLE;
        endcase
    end
end 


// 两段式状态机

reg [3:0]cstate;
reg [3:0]nstate;

always @(posedge clk or negedge rst_n) begin
    if(! rst_n) cstate <= IDLE;
    else cstate <= nstate;
end

always @(cstate or wr_req or rd_req) begin
    case(cstate)
        IDLE: begin
                if(wr_req) begin
                    natate <= WR_S1;
                    cmd <=  3'b011;
                end
                else if(rd_req) begin
                    nstate <= RD_S1;
                    cmd <= 3'b011;
                end
                else begin
                    nstate = IDLE;
                    cmd = 3'b111;
                end
            end
        WR_S1: begin
                 natate <= WR_S2;
                 cmd <= 3'b101;
            end
        WR_S2: begin
                 nstate <= IDLE;
                 cmd <= 3'b111;
            end
        RD_S1: begin
                 if(wr_req) begin
                     natate = WR_S2;
                     cmd = 3'b101;
                 end
                 else begin
                     natate = RD_S2;
                     cmd = 3'b110;
                 end
            end 
        RD_S2: begin
                 if(wr_req) begin
                     natate = WR_S1;
                     cmd = 3'b011;
                 end
                 else begin
                     natate = IDLE;
                     cmd = 3'b111;
                 end
            end
        default: natate = IDLE;
    endcase
end


//三段式状态机

reg [3:0]cstate;
reg [3:0]nstate;

always @(posedge clk or negedge rst_n) begin
    if(! rst_n) catate <= IDLE;
    else cstate <= nstate;
end

always @(cstate or wr_req or rd_req) begin
    case(cstate)
        IDLE: if(wr_req) nstate = WR_S1;
              else if(rd_req) nstate = RD_S1;
              else nstate = IDLE;
        WR_S1: nstate = WR_S2;
        WR_S2: natate = IDLE;
        RD_S1: if(wr_req) nstate = WR_S2;
               else nstate = RD_S2;
        RD_S2: if (wr_req) nstate = WR_S1;
               else nstate = IDLE;
        default: nstate = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(! rst_n) cmd = 3'b111;
    else begin
        case(nstate)
            IDLE: if(wr_req) cmd <= 3'b011;
                  else if(rd_req) cmd <= 3'b011;
                  else cmd <= 3'b111;
            WR_S1: cmd <= 3'b101;
            WR_S2: cmd <= 3'b111;
            RD_S1: if(wr_req) cmd <=3'b011;
                   else cmd <= 3'b110;
            RD_S2: if(wr_req) cmd <= 3'b011;
                   else cmd <= 3'b111;
            default；；
        endcase 
    end
end
endmodule
