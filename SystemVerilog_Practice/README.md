# Setup

In the command prompt run:  

    cmd.exe /k "C:\Xilinx\Vivado\2024.2\settings64.bat"

To execute the program, run the following commands in order:

    xvlog --sv path-to-source-file
    xelab <top_module_name> -s <sim_name>
    xsim <sim_name> -runall

To view an interactive waveform:

    xsim <sim_name> -gui

