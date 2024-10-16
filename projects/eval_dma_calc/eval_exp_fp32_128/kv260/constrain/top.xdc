
#set_max_delay -datapath_only -from [get_clocks clk_out1_design_1_clk_wiz_0_0] -to [get_clocks clk_out2_design_1_clk_wiz_0_0] 2.000
#set_max_delay -datapath_only -from [get_clocks clk_out2_design_1_clk_wiz_0_0] -to [get_clocks clk_out1_design_1_clk_wiz_0_0] 2.000

# fan
set_property PACKAGE_PIN A12 [get_ports fan_en]
set_property IOSTANDARD LVCMOS33 [get_ports fan_en]
