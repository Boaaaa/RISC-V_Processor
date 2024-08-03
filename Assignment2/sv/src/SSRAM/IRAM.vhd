library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IRAM is
  port (
    CLK    : in  std_logic;
    RSTn   : in  std_logic;
    web    : in  std_logic;
    addr   : in  std_logic_vector(31 downto 0);
    din    : in  std_logic_vector(31 downto 0);
    dout   : out std_logic_vector(31 downto 0));
end IRAM;

architecture beh of IRAM is
  
  component sram_32_1024_freepdk45 is
    port (
      clk0 : in std_logic;
      csb0 : in std_logic;
      web0 : in std_logic;
      addr0 : in std_logic_vector(9 downto 0);
      din0  : in std_logic_vector(31 downto 0);
      dout0 : out std_logic_vector(31 downto 0));
  end component;

  signal dout_temp1 : std_logic_vector(31 downto 0) := (others => '0');
  signal dout_temp2 : std_logic_vector(31 downto 0) := (others => '0');
  signal dout_temp3 : std_logic_vector(31 downto 0) := (others => '0');
  signal dout_temp4 : std_logic_vector(31 downto 0) := (others => '0');
  signal dout_temp : std_logic_vector(31 downto 0) := (others => '0');
  signal csb1 : std_logic;
  signal csb2 : std_logic;
  signal csb3 : std_logic;
  signal csb4 : std_logic;
  signal web0 : std_logic;
  signal din0 : std_logic_vector(31 downto 0);
  signal addr0 : std_logic_vector(31 downto 0);
begin

  process (CLK, RSTn) is
  begin  -- process
    if RSTn = '0' then                  -- asynchronous reset (active low)
        din0 <= (others => '0') after 1 ns;
  	addr0 <= (others => '0') after 1 ns;
  	web0 <= '0' after 1 ns;
  	csb1 <= '1' after 1 ns;
  	csb2 <= '1' after 1 ns;
  	csb3 <= '1' after 1 ns;
  	csb4 <= '1' after 1 ns;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
	din0 <= din after 1 ns;
  	addr0 <= addr after 1 ns;
  	web0 <= web after 1 ns;
  	csb1 <= not(not(addr0(11)) and not(addr0(10))) after 1 ns;
  	csb2 <= not(not(addr0(11)) and addr0(10)) after 1 ns;
  	csb3 <= not(addr0(11) and not(addr0(10))) after 1 ns;
  	csb4 <= not(addr0(11) and addr0(10)) after 1 ns;
    end if;
  end process;

 iram1 : sram_32_1024_freepdk45
    port map (
      clk0  => CLK,
      csb0  => csb1,
      web0  => web0,
      addr0 => addr0(9 downto 0),
      din0  => din0,
      dout0 => dout_temp1);

  iram2 : sram_32_1024_freepdk45
    port map (
      clk0  => CLK,
      csb0  => csb2,
      web0  => web0,
      addr0 => addr0(9 downto 0),
      din0  => din0,
      dout0 => dout_temp2);

  iram3 : sram_32_1024_freepdk45
    port map (
      clk0  => CLK,
      csb0  => csb3,
      web0  => web0,
      addr0 => addr0(9 downto 0),
      din0  => din0,
      dout0 => dout_temp3);

  iram4 : sram_32_1024_freepdk45
    port map (
      clk0  => CLK,
      csb0  => csb4,
      web0  => web0,
      addr0 => addr0(9 downto 0),
      din0  => din0,
      dout0 => dout_temp4);


  process (CLK, RSTn) is
  begin  -- process
    if RSTn = '0' then                  -- asynchronous reset (active low)
	dout_temp <= (others => '0') after 1 ns;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
	if(csb1 = '0') then
		dout_temp <= dout_temp1 after 1 ns;
	elsif(csb2 = '0') then
		dout_temp <= dout_temp2 after 1 ns;
	elsif(csb3 = '0') then
		dout_temp <= dout_temp3 after 1 ns;
	elsif(csb4 = '0') then
		dout_temp <= dout_temp4 after 1 ns;
	end if;
    end if;
  end process;

dout <= dout_temp;
end beh;


