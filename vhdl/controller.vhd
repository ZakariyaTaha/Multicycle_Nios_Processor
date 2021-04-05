library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
type StateType IS (FETCH1 , FETCH2 ,DECODE ,I_OP , R_OP,STORE , BREAK ,LOAD1, LOAD2, CALL, BRANCH, CALLR, JMP, JMPI, IOP2, ROP2);
signal s_current , s_next : StateType ; 
begin

dff : process(clk , reset_n)
begin
if(reset_n = '0') then s_current <= FETCH1 ;
elsif (rising_edge(clk)) then s_current <= s_next ;
end if ;

end process ;

transition : process(s_current)
begin
branch_op <= '0' ;
imm_signed <= '0' ;
ir_en <= '0' ;
pc_add_imm<= '0' ;
pc_en<= '0' ;
pc_sel_a <= '0' ;
pc_sel_imm <= '0' ;
rf_wren <= '0' ;
sel_addr<= '0' ;
sel_b<= '0' ;
sel_mem<= '0' ;
sel_pc<= '0' ;
sel_ra<= '0' ;
sel_rC<= '0' ;
read <= '0' ;
write <= '0' ;
case(s_current) is
when(FETCH1) => read <= '1' ;
                s_next <= FETCH2 ;

when(FETCH2) => pc_en <= '1' ;
                ir_en <= '1' ;
                s_next <= DECODE ;

when(DECODE) => if("00" & op = x"04" or "00" & op = x"08" or "00" & op = x"10" or "00" & op = x"18" or
                 "00" & op = x"20") then s_next <= I_OP ; 

                elsif(("00" & op = x"3A" and "00" & opx = x"31") or ("00" & op = x"3A" and "00" & opx = x"39") or 
                    ("00" & op = x"3A" and "00" & opx = x"08") or ("00" & op = x"3A" and "00" & opx = x"10") or 
                    ("00" & op = x"3A" and "00" & opx = x"06") or ("00" & op = x"3A" and "00" & opx = x"0E") or 
                    ("00" & op = x"3A" and "00" & opx = x"16") or ("00" & op = x"3A" and "00" & opx = x"1E") or 
                    ("00" & op = x"3A" and "00" & opx = x"13") or ("00" & op = x"3A" and "00" & opx = x"1B") or 
                    ("00" & op = x"3A" and "00" & opx = x"3B") or ("00" & op = x"3A" and "00" & opx = x"18") or 
                    ("00" & op = x"3A" and "00" & opx = x"20") or ("00" & op = x"3A" and "00" & opx = x"28") or 
                    ("00" & op = x"3A" and "00" & opx = x"30") or ("00" & op = x"3A" and "00" & opx = x"03") or 
                    ("00" & op = x"3A" and "00" & opx = x"0B")) then s_next <= R_OP ;

		elsif ("00" & op = x"17") then s_next <= LOAD1 ; 

		elsif("00" & op = x"15") then s_next <= STORE ;

		elsif ("00" & op = x"3A" and "00" & opx = x"34") then s_next <= BREAK ;

        elsif("00" & op = x"06" or "00" & op = x"0E" or "00" & op = x"16" or "00" & op = x"1E"
            or "00" & op = x"26" or "00" & op = x"2E" or "00" & op = x"36") then s_next <= BRANCH;

        elsif("00" & op = x"00") then s_next <= CALL;

        elsif("00" & op = x"3A" and "00" & opx = x"1D") then s_next <= CALLR;

        elsif(("00" & op = x"3A" and "00" & opx = x"0D") or ("00" & op = x"3A" and "00" & opx = x"05")) then s_next <= JMP;

        elsif("00" & op = x"01") then s_next <= JMPI;

        elsif("00" & op = x"0C" or "00" & op = x"14" or "00" & op = x"1C" or "00" & op = x"28"
            or "00" & op = x"30") then s_next <= IOP2;

        elsif(("00" & op = x"3A" and "00" & opx = x"12") or ("00" & op = x"3A" and "00" & opx = x"1A") or 
              ("00" & op = x"3A" and "00" & opx = x"3A") or ("00" & op = x"3A" and "00" & opx = x"02")) then s_next <= ROP2;

        end if;


when(I_OP) =>                       rf_wren <='1'  ; 
                                    imm_signed <='1' ;
                                    s_next <= FETCH1 ;
 		

when(R_OP) =>
                                    rf_wren <='1' ;
                                    sel_b <='1' ;
                                    sel_rC <='1';
                                    s_next <= FETCH1 ;
		

when(LOAD1) =>  
                                sel_addr <='1' ;
				                imm_signed <= '1' ;
                                read <='1' ;
                                s_next <= LOAD2 ; 
		
when(LOAD2) =>  rf_wren <= '1' ;
                sel_mem <='1' ;
                s_next <= FETCH1 ;

when(STORE) =>               
                                write <='1' ;
				                imm_signed <= '1' ;
                                sel_addr <= '1' ;
                                sel_b <= '0' ;
                                s_next <= FETCH1 ;


when(BREAK) => s_next <= BREAK ;

when(BRANCH) => pc_add_imm <= '1';
                sel_b <= '1';
                branch_op <= '1';
                s_next <= FETCH1 ;

when(CALL) => sel_pc <= '1';
              pc_en <= '1';
              sel_ra <= '1';
              rf_wren <= '1';
              pc_sel_imm <= '1';
              s_next <= FETCH1;

when(CALLR) => rf_wren <= '1'; -- Pas de ALU donc pas de op_alu pour CALLR --
               pc_en <= '1';
               pc_sel_a <= '1';
               sel_pc <= '1';
               sel_ra <= '1';
               s_next <= FETCH1;

when(JMP) => pc_en <= '1';
             pc_sel_a <= '1';
             s_next <= FETCH1;

when(JMPI) => pc_en <= '1';
              pc_sel_imm <= '1';
              s_next <= FETCH1;

when(IOP2) => rf_wren <='1'  ; 
              s_next <= FETCH1 ;

when(ROP2) =>                       rf_wren <='1' ; -- sel_b = '0'
                                    sel_rC <='1';
                                    s_next <= FETCH1 ;

when others => s_next <= FETCH1 ;




end case ;
end process ;

aluProcess : process (op ,opx)
begin
    if("00" & op = x"04") or ("00" & op = x"17") or ("00" & op = x"15") then op_alu <= "000" & op(5 downto 3)  ;

    elsif ("00" & op = x"06") then op_alu <= "011100" ;

    elsif ("00" & op = x"0E" or "00" & op = x"16" or"00" & op = x"1E" or "00" & op = x"26" 
        or "00" & op = x"2E" or "00" & op = x"36") then op_alu <= "011" & op(5 downto 3) ;

    elsif("00" & op = x"08" or "00" & op = x"10" or "00" & op = x"18" or "00" & op = x"20") then op_alu <= "011" & op(5 downto 3);

    elsif("00" & op = x"0C" or "00" & op = x"14" or "00" & op = x"1C") then op_alu <= "100" & op(5 downto 3);

    elsif("00" & op = x"28" or "00" & op = x"30") then op_alu <= "011" & op(5 downto 3);

    elsif("00" & op = x"3A" and "00" & opx = x"31") then op_alu <= "000" & opx(5 downto 3);

    elsif("00" & op = x"3A" and "00" & opx = x"39") then op_alu <= "001" & opx(5 downto 3);

    elsif(("00" & op = x"3A" and "00" & opx = x"08") or ("00" & op = x"3A" and "00" & opx = x"10") or
         ("00" & op = x"3A" and "00" & opx = x"18") or ("00" & op = x"3A" and "00" & opx = x"20") or 
         ("00" & op = x"3A" and "00" & opx = x"28") or ("00" & op = x"3A" and "00" & opx = x"30")) then op_alu <= "011" & opx(5 downto 3);

    elsif(("00" & op = x"3A" and "00" & opx = x"06") or ("00" & op = x"3A" and "00" & opx = x"0E") or 
        ("00" & op = x"3A" and "00" & opx = x"16") or ("00" & op = x"3A" and "00" & opx = x"1E")) then op_alu <= "100" & opx(5 downto 3);

    elsif(("00" & op = x"3A" and "00" & opx = x"13") or ("00" & op = x"3A" and "00" & opx = x"1B") or 
        ("00" & op = x"3A" and "00" & opx = x"3B") or ("00" & op = x"3A" and "00" & opx = x"03") or 
        ("00" & op = x"3A" and "00" & opx = x"0B") or ("00" & op = x"3A" and "00" & opx = x"12") or ("00" & op = x"3A" and "00" & opx = x"1A") or 
        ("00" & op = x"3A" and "00" & opx = x"3A") or ("00" & op = x"3A" and "00" & opx = x"02")) then op_alu <= "110" & opx(5 downto 3);

    end if;

end process ;




end synth;
