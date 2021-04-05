library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
signal s_r ,s_sum: std_logic_vector(32 downto 0) ;


begin
s_sum <= std_logic_vector(unsigned('0' & a) + unsigned('0' & not(b)));
s_r <=  std_logic_vector(unsigned (s_sum) + to_unsigned(1,33)) when sub_mode = '1' else std_logic_vector(unsigned('0' & a) + unsigned('0' & b))  ;
r<= s_r(31 downto 0) ;
carry <= s_r(32) ;
zero <= '1' when s_r(31 downto 0) = std_logic_vector(to_unsigned(0,32)) else '0' ;
end synth;